import 'package:eventify/providers/event_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class CategoryButton extends StatelessWidget{

  final String categoryName;

  const CategoryButton({super.key, required this.categoryName});


  @override
  Widget build(BuildContext context) {

    EventProvider eventProvider = context.read<EventProvider>();

    return FloatingActionButton.small(
      onPressed: categoryName=='All'?
        eventProvider.getEvents
        : () => eventProvider.getUpcomingEventsByCategory(categoryName),
      backgroundColor: const Color(0xFF3C4869),
      foregroundColor: Colors.white,
      child: selectIcon(categoryName),
      shape: const CircleBorder(),

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

