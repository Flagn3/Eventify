import 'package:eventify/providers/user_provider.dart';
import 'package:eventify/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final activeUser = userProvider.activeUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Pantalla de prueba')),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 300),
            const Text(
              '¡Pantalla de prueba!',
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            if (activeUser!=null)...{
              Text(
                'Nombre: ${activeUser.name}\n'
                'Role : ${activeUser.role}\n'
                'Token: ${activeUser.rememberToken}',
                textAlign: TextAlign.center,
              )
            },
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                // final userProvider = context.read<UserProvider>();
                await userProvider.logout();
                
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
