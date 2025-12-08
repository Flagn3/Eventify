import 'package:eventify/providers/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClearFiltersButton extends StatelessWidget {
  const ClearFiltersButton({super.key});

  @override
  Widget build(BuildContext context) {
    final eventProvider = context.watch<EventProvider>();

    // Si no hay filtros activos, no mostramos nada
    if (eventProvider.activeCategory == null) return SizedBox.shrink();

    return Positioned(
      left: 16,
      bottom: 16,
      child: FloatingActionButton.extended(
        onPressed: () {
          context.read<EventProvider>().getEvents();
        },
        backgroundColor: const Color(0xFF3C4869),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.close),
        label: const Text("Quitar filtro"),
        heroTag: null
      ),
    );
  }
}
