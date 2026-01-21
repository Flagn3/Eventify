import 'package:eventify/models/event.dart';
import 'package:eventify/models/user.dart';
import 'package:eventify/providers/event_provider.dart';
import 'package:eventify/providers/user_provider.dart';
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
  late TextEditingController startTimeController;
  late TextEditingController endTimeController;


  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.event.title);
    descriptionController = TextEditingController(text: widget.event.description);
    categoryController = TextEditingController(text: widget.event.category);
    // TODO: review how to put into a calendar widget the original date
    //startTimeController = TextEditingController(text: widget.event.startTime);
    //endTimeController = TextEditingController(text: widget.event.endTime);
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    categoryController.dispose();
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
            eventProvider.isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      // Validamos que el nombre no esté vacío
                      if (titleController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("El título no puede estar vacío")),
                        );
                        return;
                      }
                      // TODO: finish the edit screen
                      /*
                      await eventProvider.updateEvent(
                          widget.user.id, nameController.text.trim()
                      );
                      */
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
          ],
        ),
      ),
    );
  }
}