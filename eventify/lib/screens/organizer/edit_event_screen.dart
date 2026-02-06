import 'package:eventify/models/event.dart';
import 'package:eventify/models/user.dart';
import 'package:eventify/providers/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditEventScreen extends StatefulWidget {
  final Event event;
  final User user;

  const EditEventScreen({
    super.key,
    required this.event,
    required this.user,
  });

  @override
  State<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  int? selectedCategoryId;

  DateTime? startDate;
  DateTime? endDate;

  final Map<int, String> categoryOptions = {
    1: 'Music',
    2: 'Sport',
    3: 'Technology',
    4: 'Cultural',
  };

  final Map<int, String> categoryImages = {
    1: 'https://apiflutter.iaknowhow.es/public/images/musica.jpg',
    2: 'https://apiflutter.iaknowhow.es/public/images/deporte.jpg',
    3: 'https://apiflutter.iaknowhow.es/public/images/tecnologia.jpg',
    4: 'https://apiflutter.iaknowhow.es/public/images/reyes.png',
    };

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: widget.event.title);
    descriptionController =
        TextEditingController(text: widget.event.description ?? '');

    selectedCategoryId = widget.event.categoryId;

    startDate = widget.event.startTime;
    endDate = widget.event.endTime;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = context.watch<EventProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Evento"),
        backgroundColor: const Color(0xFFE35EB3),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // TITLE
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Titulo",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // DESCRIPTION
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: "Descripción",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // CATEGORY DROPDOWN
            DropdownButtonFormField<int>(
              value: selectedCategoryId,
              decoration: InputDecoration(
                labelText: "Categoria",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: categoryOptions.entries
                  .map(
                    (e) => DropdownMenuItem<int>(
                      value: e.key,
                      child: Text(e.value),
                    ),
                  )
                  .toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedCategoryId = newValue!;
                });
              },
            ),

            const SizedBox(height: 20),

            // START DATE
            _buildDateField("Fecha inicio", startDate, (date) {
              setState(() => startDate = date);
            }),

            // END DATE
            _buildDateField("Fecha fin", endDate, (date) {
              setState(() => endDate = date);
            }),

            const SizedBox(height: 20),

            eventProvider.isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      if (titleController.text.trim().isEmpty) {
                        _showError("El título no puede estar vacío");
                        return;
                      }

                      if (descriptionController.text.trim().isEmpty) {
                        _showError("La descripción no puede estar vacía");
                        return;
                      }

                      if (selectedCategoryId == null) {
                        _showError("Debes elegir una categoría");
                        return;
                      }

                      if (startDate == null) {
                        _showError("Selecciona fecha de inicio");
                        return;
                      }

                      if (endDate == null) {
                        _showError("Selecciona fecha de fin");
                        return;
                      }

                      if (endDate!.isBefore(startDate!)) {
                        _showError(
                          "La fecha final no puede ser anterior a la inicial",
                        );
                        return;
                      }

                      final newStart = buildDateTime(
                        startDate!,
                        widget.event.startTime,
                      );

                      final newEnd = buildDateTime(
                        endDate!,
                        widget.event.endTime,
                      );

                      final imageUrl = categoryImages[selectedCategoryId] ?? widget.event.imageUrl;

                      await eventProvider.updateEvent(
                        widget.event.id,
                        widget.user.id,
                        titleController.text.trim(),
                        descriptionController.text.trim(),
                        selectedCategoryId!,
                        newStart,
                        newEnd,
                        widget.event.location,
                        widget.event.latitude,
                        widget.event.longitude,
                        widget.event.maxAttendees,
                        widget.event.price,
                        imageUrl,
                      );
                      await eventProvider.refreshOrganizerEvents();

                      await eventProvider
                          .getEventsByOrganizer(widget.user.id);

                      if (eventProvider.errorMessage == null) {
                        if (!mounted) return;

                        Navigator.pop(context);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Evento editado con éxito"),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text(eventProvider.errorMessage ?? ""),
                          ),
                        );
                      }
                    },
                    child: const Text("Guardar"),
                  ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Volver"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField(
    String label,
    DateTime? value,
    Function(DateTime) onSelected,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      subtitle: Text(
        value == null
            ? "Seleccionar fecha"
            : "${value.day}-${value.month}-${value.year}",
      ),
      trailing: const Icon(Icons.calendar_today),
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: value ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2035),
        );

        if (!mounted) return;

        if (date != null) onSelected(date);
      },
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red,
      ),
    );
  }

  DateTime buildDateTime(DateTime date, DateTime original) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      original.hour,
      original.minute,
      original.second,
    );
  }
}
