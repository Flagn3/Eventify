import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eventify/providers/user_provider.dart';
import 'package:eventify/models/user.dart';

class EditUserScreen extends StatefulWidget {
  final User user;

  const EditUserScreen({super.key, required this.user});

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    // Inicializamos el campo con el nombre actual del usuario
    nameController = TextEditingController(text: widget.user.name);
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    final userProvider = context.watch<UserProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar usuario"),
        backgroundColor: const Color(0xFFE35EB3),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Nombre",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            userProvider.loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      // Validamos que el nombre no esté vacío
                      if (nameController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("El nombre no puede estar vacío")),
                        );
                        return;
                      }

                      await userProvider.updateUser(
                          widget.user.id, nameController.text.trim()
                      );
                      
                      await userProvider.getUsers();

                      if (userProvider.errorMessage == null) {
                        
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Usuario editado con éxito') ,
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 2),
                          )
                        );

                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(userProvider.errorMessage ?? '')),
                        );
                      }
                    },
                    child: const Text("Guardar"),
                  ),
          ],
        ),
      ),
    );
  }
}