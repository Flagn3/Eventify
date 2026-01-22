import 'package:eventify/models/event.dart';
// import 'package:eventify/providers/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final Widget? actions;
  // final EventProvider eventProvider;

  const EventCard({
    super.key,
    required this.event,
    this.actions
  });

  @override
  Widget build(BuildContext context) {

    final selectedColor = cardColor();
    final String formatDate = DateFormat('dd-MM-yyyy').format(event.startTime);
    final String formatHour = DateFormat('HH:mm').format(event.startTime);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      //decoración
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: selectedColor, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 4,
            offset: const Offset(3, 7),
          )
        ]
      ),

      child: Column(
        children: [
          //cabecera de color
          Container(
            height: 23,
            decoration: BoxDecoration(
              color: selectedColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              )
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                //imagen
                Hero(tag: 'event-image-${event.id}',
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      event.imageUrl,
                      width: 165,
                      height: 165,
                      fit: BoxFit.cover,
                      // errorBuilder: ,    //ponerle un placeholder por si falla
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                //titulo fecha y hora
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //titulo
                      Text(
                        event.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 16),
                      //fecha
                      Row(
                        children: [
                          const Icon(Icons.calendar_month, size: 18, fontWeight: FontWeight.bold,),
                          const SizedBox(width: 6,),
                          Text(
                            formatDate,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      //hora
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 18, fontWeight: FontWeight.bold,),
                          const SizedBox(width: 6,),
                          Text(
                            formatHour,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  )
                  )
              ],
            ),
            ),

            //para los botones
            if (actions!=null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16), 
                child: actions!,
              ),
        ],
        
      ),

      


    );
  }

  Color cardColor() {
    switch (event.category.toLowerCase()){
      case 'music':
        return Color(0xFFFFD700);
      case 'sport':
        return Color(0xFFFF4500);
      case 'technology':
        return Color(0xFF4CAF50);
      case 'cultural':
        return Color(0xFF00AAFF);
      default:
        return Colors.black;
    }
    
    
  }
}
