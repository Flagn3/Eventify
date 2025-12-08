import 'package:eventify/providers/event_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class CategoryButton extends StatelessWidget{

  final String categoryName;

  const CategoryButton({super.key, required this.categoryName});


  @override
  Widget build(BuildContext context) {

    EventProvider eventProvider = context.watch<EventProvider>();

    final isSelected = eventProvider.activeCategory?.toLowerCase() == categoryName.toLowerCase();

    return FloatingActionButton.small(
      onPressed: categoryName=='All'?
        eventProvider.getEvents
        : () => eventProvider.getUpcomingEventsByCategory(categoryName),
      backgroundColor: isSelected ? Color(0xFFE53DB2) : const Color(0xFF3C4869),
      foregroundColor: Colors.white,
      child: selectIcon(categoryName),
      shape: const CircleBorder(),
      heroTag: null

    );
  }

}

selectIcon(String categoryName) {
  switch (categoryName.toLowerCase()){
    case 'music':
        return const Icon(Icons.music_note);
      case 'sport':
        return const Icon(Icons.sports_tennis);
      case 'technology':
        return const Icon(Icons.computer);
      case 'cultural':
        return const Icon(Icons.theater_comedy);
      default:
        return const Icon(Icons.close);
  }
}

