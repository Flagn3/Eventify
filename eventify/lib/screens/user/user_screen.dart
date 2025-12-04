import 'package:eventify/providers/event_provider.dart';
import 'package:eventify/screens/user/events_screen.dart';
import 'package:eventify/widgets/filter_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:provider/provider.dart';


class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<StatefulWidget> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  
  int currentIndex = 0;
  bool showFilterButtons = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<EventProvider>().getEvents();
    });

    // final eventProvider = context.read<EventProvider>().getEvents();

  }

  final List<Widget> _pages = [
    const Center(child: Text('Home'),),    // Vista separada
    const EventsScreen(),  // Vista separada
  ];


  @override
  Widget build(BuildContext context) {
    // final eventProvider = Provider.of<EventProvider>(context);

    return Scaffold(
      backgroundColor: Color(0xFFEFEFF0),
      appBar: AppBar(
        title: const Text('Cabecera'),
        centerTitle: true,
        elevation: 15,
        backgroundColor: Color(0xFFE53DB2),
      ),
      //body
      body: IndexedStack(
        index: currentIndex,
        children: _pages,
      ),

      //FAB
      floatingActionButton: currentIndex==1 ? const FilterButton() : null,  //pasarle el provider?
      floatingActionButtonLocation: ExpandableFab.location,
          
          

      //Bottom navbar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home'
            ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_outlined),
            activeIcon: Icon(Icons.event),
            label: 'Events'
            )
        ],
        backgroundColor: Color(0xFFE53DB2),
        ),
    );
    
  }
  
  
}
