
// import 'package:eventify/Screens/register_screen.dart';
import 'package:eventify/providers/category_provider.dart';
import 'package:eventify/providers/event_provider.dart';
import 'package:eventify/providers/user_provider.dart';
import 'package:eventify/screens/login/login_screen.dart';
// import 'package:eventify/services/event_service.dart';
import 'package:eventify/providers/event_attendees_provider.dart';
import 'package:eventify/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider(UserService())),
        ChangeNotifierProxyProvider<UserProvider, EventProvider>(
          create: (context) => EventProvider(context.read<UserProvider>()),
          update: (context, userProvider, previous) => EventProvider(userProvider),
        ),
        ChangeNotifierProxyProvider<UserProvider, CategoryProvider>(
          create: (context) => CategoryProvider(context.read<UserProvider>()),
          update: (context, userProvider, previous) => CategoryProvider(userProvider),
        ),
          ChangeNotifierProxyProvider<UserProvider, EventAttendeesProvider>(
          create: (context) =>
              EventAttendeesProvider(context.read<UserProvider>()),
          update: (context, userProvider, previous) =>
              EventAttendeesProvider(userProvider),
        ),

      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}
