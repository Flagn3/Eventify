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
    final eventProvider = Provider.of<EventProvider>(context);
    
    // Aquí obtienes el ID del usuario logueado
    final userId = Provider.of<UserProvider>(context, listen: false).activeUser!.id;

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
                    .map((event) => EventCard(event: event))
                    .toList(),
          ),
        ),
        if (eventProvider.activeCategory != null)
          ClearFiltersButton(),
      ],
    );
  }
}

