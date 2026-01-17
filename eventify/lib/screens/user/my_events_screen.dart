import 'package:eventify/providers/event_attendees_provider.dart';
import 'package:eventify/providers/user_provider.dart';
import 'package:eventify/widgets/clear_filters_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eventify/providers/event_provider.dart';
import 'package:eventify/widgets/event_card.dart';

class MyEventsScreen extends StatelessWidget {
  const MyEventsScreen({super.key});

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
                        child: Text("No estás inscrito en ningún evento"),
                      ),
                    ),
                  ]
                : eventProvider.myEvents.map((event) {
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
                                  title: const Text('Cancelar registro'),
                                  content: Text(
                                      '¿Quieres cancelar tu registro en "${event.title}"?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text('No'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text('Sí, cancelar'),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm == true) {

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
                                    content: Text("Registro cancelado correctamente"),
                                  ),
                                );

                                await eventProvider.getEventsByUser(userId);
                                //actualizar los otros eventos
                                await eventProvider.getEvents();
                              }

                            },
                            icon: const Icon(Icons.close),
                            label: const Text("Cancelar registro"),
                          ),

                          // Ver info
                          OutlinedButton.icon(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: Text(event.title),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Categoría: ${event.category}"),
                                        const SizedBox(height: 8),
                                        Text("Fecha: ${event.startTime}"),
                                        const SizedBox(height: 8),
                                        Text(event.description ?? "Sin descripción"),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context),
                                      child: const Text("Cerrar"),
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: const Icon(Icons.info_outline),
                            label: const Text("Ver info"),
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
