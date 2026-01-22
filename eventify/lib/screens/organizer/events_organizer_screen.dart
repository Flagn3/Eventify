import 'package:eventify/providers/user_provider.dart';
import 'package:eventify/screens/organizer/edit_event_screen.dart';
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

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final userId = user.id;

    if (eventProvider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (eventProvider.errorMessage != null) {
      return Scaffold(
        body: Center(child: Text(eventProvider.errorMessage!)),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () => eventProvider.getEventsByOrganizer(userId),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: eventProvider.eventsByOrganizer.isEmpty
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
                            // ELIMINAR
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
                                  await eventProvider.deleteEvent(event.id);

                                  if (eventProvider.errorMessage != null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            eventProvider.errorMessage!),
                                      ),
                                    );
                                    return;
                                  }

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          "Evento eliminado correctamente"),
                                    ),
                                  );

                                  await eventProvider
                                      .getEventsByOrganizer(userId);
                                }
                              },
                              icon: const Icon(Icons.close),
                              label: const Text("Eliminar"),
                            ),

                            // EDITAR
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.yellow,
                                foregroundColor: Colors.black,
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
                                        child: const Text('Sí, editar'),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirm == true) {
                                  await Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EditEventScreen(
                                        event: event,
                                        user: user,
                                      ),
                                    ),
                                  );

                                  await eventProvider
                                      .getEventsByOrganizer(userId);
                                }
                              },
                              icon: const Icon(Icons.edit),
                              label: const Text("Editar"),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
            ),
          ),

          if (eventProvider.activeCategory != null)
            const ClearFiltersButton(),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: ir a crear evento
        },
        backgroundColor: const Color(0xFFE35EB3),
        child: const Icon(Icons.add),
      ),
    );
  }
}
