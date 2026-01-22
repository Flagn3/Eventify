import 'package:eventify/models/user.dart';
import 'package:eventify/providers/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateEventScreen extends StatefulWidget {
  final User user;
  const CreateEventScreen({super.key, required this.user});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreemState();
}

class _CreateEventScreemState extends State<CreateEventScreen> {

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  
  int? price;
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
  Widget build(BuildContext context) {
    final eventProvider = context.watch<EventProvider>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crear Evento"),
        backgroundColor: const Color(0xFFE35EB3),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView( 
          child:  Column(
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

              
              // DESCRIPTION
              TextField(
                controller: locationController,
                decoration: const InputDecoration(
                  labelText: "Localización",
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

              // DESCRIPTION
              TextField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: "Precio",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              _buildDateTimeField("Fecha inicio", startDate, (date) {
                if (!mounted) return;
                setState(() => startDate = date);
              }),

              _buildDateTimeField("Fecha fin", endDate, (date) {
                if (!mounted) return;
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

                        final imageUrl = categoryImages[selectedCategoryId];
                        if (priceController.text.trim().isNotEmpty) {
                          try {
                            price = int.parse(priceController.text.trim());
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("El precio debe ser un número")),
                            );
                            return;
                          }
                        } else {
                          price = 0;
                        }
                        final start = startDate!;
                        final end = endDate!;

                        await eventProvider.createEvent(widget.user.id, titleController.text.trim(), 
                          descriptionController.text.trim(), selectedCategoryId!, 
                          start, end, locationController.text.trim(), price, imageUrl!
                        );
                        await eventProvider
                            .getEventsByOrganizer(widget.user.id);

                        if (eventProvider.errorMessage == null) {
                          if (!mounted) return;

                          Navigator.pop(context);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Evento creado con éxito"),
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
                    child: const Text("Crear")
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
      )
    );
  }



  Widget _buildDateTimeField(
    String label,
    DateTime? value,
    Function(DateTime) onSelected,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      subtitle: Text(
        value == null
            ? "Seleccionar fecha y hora"
            : "${value.day}-${value.month}-${value.year} ${value.hour.toString().padLeft(2,'0')}:${value.minute.toString().padLeft(2,'0')}",
      ),
      trailing: const Icon(Icons.calendar_today),
      onTap: () async {
        // 1️⃣ Pick the date
        final date = await showDatePicker(
          context: context,
          initialDate: value ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (!mounted || date == null) return;

        // 2️⃣ Pick the time
        final time = await showTimePicker(
          context: context,
          initialTime: value != null
              ? TimeOfDay(hour: value.hour, minute: value.minute)
              : const TimeOfDay(hour: 12, minute: 0),
        );
        if (!mounted || time == null) return;

        // 3️⃣ Combine date + time
        final dateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );

        onSelected(dateTime);
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

}