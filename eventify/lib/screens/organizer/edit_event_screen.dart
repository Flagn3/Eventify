import 'package:eventify/models/event.dart';
import 'package:eventify/models/user.dart';
import 'package:eventify/providers/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditEventScreen extends StatefulWidget {
  final Event event;
  final User user;

  const EditEventScreen({super.key, required this.event, required this.user});

  @override
  State<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController categoryController;
  late String selectedCategory;

  DateTime? startDate;
  DateTime? endDate;

  final List<String> categoryOptions = [
    'Sport',
    'Cultural',
    'Technology',
    'Music',
  ];


  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.event.title);
    descriptionController = TextEditingController(text: widget.event.description);
    categoryController = TextEditingController(text: widget.event.category);
    selectedCategory = widget.event.category;
    startDate = widget.event.startTime;
    endDate = widget.event.endTime;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    /*
    startTimeController.dispose();
    endTimeController.dispose();
    */
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
        padding: const EdgeInsets.all(20.0),     
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Titulo",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: "Descripción",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20,),
            DropdownButtonFormField<String>(
              value: categoryOptions.contains(selectedCategory)
                  ? selectedCategory
                  : null,
              decoration: InputDecoration(
                labelText: "Categoria",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: categoryOptions
                  .map(
                    (value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    ),
                  )
                  .toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedCategory = newValue!;
                  categoryController.text = newValue;
                });
              },
            ),
            const SizedBox(height: 20),

            _buildDateField("Fecha inicio", startDate, (date) {
              setState(() => startDate = date);
            }),

            _buildDateField("Fecha fin", endDate, (date) {
              setState(() => endDate = date);
            }),
            const SizedBox(height: 20),
            eventProvider.isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      // Validamos que el nombre no esté vacío
                      if (titleController.text.trim().isEmpty) {
                        _showError("El título no puede estar vacío");
                        return;
                      }

                      if (descriptionController.text.trim().isEmpty) {
                        _showError("La descripción no puede estar vacía");
                        return;
                      }

                      if (selectedCategory.isEmpty) {
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
                        _showError("La fecha final no puede ser anterior a la inicial");
                        return;
                      }
                      // TODO: finish the edit screen
                      
                      await eventProvider.updateEvent(
                          widget.event.id, widget.user.id, titleController.text.trim(), descriptionController.text.trim(),
                          categoryController.text.trim(), startDate!, endDate!, widget.event.location,
                          widget.event.latitude, widget.event.longitude, widget.event.maxAttendees,
                          widget.event.price, widget.event.imageUrl  
                      );
                      
                      await eventProvider.getEventsByOrganizer(widget.user.id);

                      if (eventProvider.errorMessage == null) {
                        
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Evento editado con éxito') ,
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 2),
                          )
                        );

                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(eventProvider.errorMessage ?? '')),
                        );
                      }
                    },
                    child: const Text("Guardar"),
                  ),
                  ElevatedButton(onPressed: (){
                    Navigator.pop(context);
                  }, child: const Text("Volver"))
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


}



