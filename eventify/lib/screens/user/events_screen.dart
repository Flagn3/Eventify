import 'package:eventify/widgets/clear_filters_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eventify/providers/event_provider.dart';
import 'package:eventify/widgets/event_card.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);

    if (eventProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (eventProvider.errorMessage != null) {
      return Center(child: Text(eventProvider.errorMessage!));
    }

    // if (eventProvider.events.isEmpty) {
    //   return const Center(child: Text("No hay eventos disponibles"));
    // }

    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: eventProvider.getEvents,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: eventProvider.events.isEmpty
                ? [
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 100,
                      child: const Center(
                        child: Text("No hay eventos disponibles"),
                      ),
                    ),
                  ]
                : eventProvider.events
                    .map((event) => EventCard(
                      event: event,
                      actions: ElevatedButton.icon(
                        //TODO: registrar usuario en evento
                        onPressed: () async{

                          final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Confirmar registro'),
                                  content: Text('¿Quieres registrarte en el evento "${event.title}"?'),
                                  actions: [
                                    TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text('Cancelar')),
                                    TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: const Text('Registrarse')),
                                  ],
                                ),
                              );

                              if (confirm == true) {
                                try{
                                  //TODO llamada a la API registrar
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Te has registrado correctamente")),
                                  );
                                  await eventProvider.getEvents();

                                } catch (e){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Error al registrarse en el evento"))
                                  );
                                }
                              }
                        }, 
                        icon: Icon(Icons.add),
                        label: const Text("Registrarse en el evento"),  
                        ),
                      ))
                    .toList(),
          ),
        ),

        if (eventProvider.activeCategory != null)
          ClearFiltersButton()
      ],
    );
  }
}
