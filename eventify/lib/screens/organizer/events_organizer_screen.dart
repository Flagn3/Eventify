import 'package:eventify/providers/event_attendees_provider.dart';
import 'package:eventify/providers/user_provider.dart';
import 'package:eventify/widgets/clear_filters_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eventify/providers/event_provider.dart';
import 'package:eventify/widgets/event_card.dart';

class EventsOrganizerScreen extends StatelessWidget {
  const EventsOrganizerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().activeUser;
    final eventProvider = context.watch<EventProvider>();
    final attendeesProvider = context.watch<EventAttendeesProvider>();

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final userId = user.id;

    if (eventProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (eventProvider.errorMessage != null) {
      return Center(child: Text(eventProvider.errorMessage!));
    }

    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () => eventProvider.getEventsByUser(userId),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: eventProvider.myEvents.isEmpty
                ? [
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 100,
                      child: const Center(
                        child: Text("No has creado ningún evento"),
                      ),
                    ),
                  ]
                : eventProvider.eventsByOrganizer.map((event) {
                    return EventCard(
                      event: event,
                      actions: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Cancelar registro
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Eliminar evento'),
                                  content: Text(
                                      '¿Quieres eliminar tu evento "${event.title}"?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text('No'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text('Sí, eliminar'),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm == true) {

                                //Change unregisterEvent for eventDelete
                                await attendeesProvider.unregisterEvent(userId, event.id);

                                if (attendeesProvider.errorMessage != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(attendeesProvider.errorMessage!),
                                    ),
                                  );
                                  return;
                                }

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Evento eliminado correctamente"),
                                  ),
                                );

                                await eventProvider.getEventsByUser(userId);
                                //actualizar los otros eventos
                                await eventProvider.getEvents();
                              }

                            },
                            icon: const Icon(Icons.close),
                            label: const Text("Eliminar evento"),
                          ),

                          // Edit event
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.yellow,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Editar evento'),
                                  content: Text(
                                      '¿Quieres editar tu evento "${event.title}"?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text('No'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text('Sí, eliminar'),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm == true) {
                                //Change unregisterEvent for eventUpdate
                                await attendeesProvider.unregisterEvent(userId, event.id);

                                if (attendeesProvider.errorMessage != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(attendeesProvider.errorMessage!),
                                    ),
                                  );
                                  return;
                                }

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Evento eliminado correctamente"),
                                  ),
                                );

                                await eventProvider.getEventsByUser(userId);
                                //actualizar los otros eventos
                                await eventProvider.getEvents();
                              }

                            },
                            icon: const Icon(Icons.edit),
                            label: const Text("Eliminar evento"),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
          ),
        ),

        if (eventProvider.activeCategory != null) ClearFiltersButton(),
      ],
    );
  }
}
