import 'package:eventify/providers/event_provider.dart';
import 'package:eventify/providers/user_provider.dart';
// import 'package:eventify/screens/login/login_screen.dart';
import 'package:eventify/screens/user/events_screen.dart';
import 'package:eventify/screens/user/home_screen.dart';
import 'package:eventify/screens/user/my_events_screen.dart';
import 'package:eventify/screens/user/report_screen.dart';
import 'package:eventify/widgets/filter_button.dart';
import 'package:eventify/widgets/logout_button.dart';
import 'package:eventify/widgets/user_avatar.dart';
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
    // const Center(child: Text('Home')),
    const HomeScreen(),
    const EventsScreen(),
    const MyEventsScreen(),
    const ReportScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // final eventProvider = Provider.of<EventProvider>(context);

    return Scaffold(
      backgroundColor: Color(0xFFEFEFF0),
      appBar: AppBar(
        title: Row(
          children: [
            UserAvatar(),
            const SizedBox(width: 16,),
            Expanded(child: Text(
              context.watch<UserProvider>().activeUser?.name ?? '',
            ))
          ],
        ) ,
        elevation: 15,
        backgroundColor: Color(0xFFE53DB2),
        actions: [
          LogoutButton()
        ],
      ),
      //body
      body: IndexedStack(index: currentIndex, children: _pages),

      //FAB
      floatingActionButton: currentIndex == 1
          ? const FilterButton()
          : null, //pasarle el provider?
      floatingActionButtonLocation: ExpandableFab.location,

      //Bottom navbar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,  //para que no cambie a shifting
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_outlined),
            activeIcon: Icon(Icons.event),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_outlined),
            activeIcon: Icon(Icons.event),
            label: 'My Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.picture_as_pdf_outlined),
            activeIcon: Icon(Icons.picture_as_pdf),
            label: 'Report',
          ),
        ],
        backgroundColor: Color(0xFFE53DB2),
      ),
    );
  }
}
