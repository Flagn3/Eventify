// import 'package:eventify/providers/event_provider.dart';
// import 'package:eventify/providers/category_provider.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'category_button.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({super.key});

  @override
  Widget build(BuildContext context) {

    // final categoryProvider = Provider.of<CategoryProvider>(context);

    return ExpandableFab(
      distance: 80,
      type: ExpandableFabType.fan,
      childrenAnimation: ExpandableFabAnimation.rotate,

      //Abrir
      openButtonBuilder: RotateFloatingActionButtonBuilder(
        child: const Icon(Icons.filter_list, color: Colors.white),
        fabSize: ExpandableFabSize.regular,
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF3C4869),
        shape: const CircleBorder(),
        heroTag: null
      ),

      //Cerrar
      closeButtonBuilder: FloatingActionButtonBuilder(
        size: 56,
        builder: (BuildContext context, void Function()? onPressed,
            Animation<double> animation) {
          return FloatingActionButton(
            heroTag: null,
            onPressed: () {
              // Quitar filtros al cerrar boton???
              // context.read<EventProvider>().getEvents();
              if (onPressed != null) onPressed();
            },
            backgroundColor: const Color(0xFF3C4869),
            foregroundColor: Colors.white,
            shape: const CircleBorder(),
            child: const Icon(Icons.filter_list_off, size: 32),
          );
        },
      ),

      children:  [
        // for (var c in categoryProvider.categories)
        //   CategoryButton(categoryName: c.name),
     
        CategoryButton(categoryName: 'Music'),
        CategoryButton(categoryName: 'Sport'),
        CategoryButton(categoryName: 'Technology'),
        CategoryButton(categoryName: 'Cultural'),
      ],
      
    );
  }
}
