import 'package:eventify/models/user.dart';
import 'package:eventify/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:eventify/providers/user_provider.dart';
import 'package:provider/provider.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  //cargar la lista de usuarios
  @override
  void initState() {
    super.initState();
    final userProvider = context.read<UserProvider>();
    userProvider.getUsers();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    List<User> usersList = userProvider.userList;

    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de usuarios"),
        backgroundColor: Color(0xFFE35EB3),
        actions: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.08,
              ),
              child: TextButton(
                child: Text(
                  "Logout",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                onPressed: () async {
                  await userProvider.logout();

                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: usersList.length,
        itemBuilder: (BuildContext context, int index) {
          final user = usersList[index];
          return ListTile(
            title: Text(user.name),
            subtitle: Text(user.email!),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Tooltip(
                //   message: "Activar usuario",
                //   child: IconButton(
                //   onPressed: (){},
                //   icon: Icon(Icons.toggle_on)
                // ),
                // ),
                ActivateDesactivateWidget(user: user),
                IconButton(onPressed: () async {
                  //Ir a formulario para editar
                    // await userProvider.updateUser(user.id, 'Pepe');
                    // await userProvider.getUsers();
                }, icon: Icon(Icons.edit)),
                IconButton(onPressed: () async {
                  await userProvider.deleteUser(user.id);
                  await userProvider.getUsers();
                }, icon: Icon(Icons.delete)),
              ],
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider();
        },
      ),
    );
  }
}

class ActivateDesactivateWidget extends StatefulWidget {
  final User user;

  const ActivateDesactivateWidget({super.key, required this.user});

  @override
  _ActivateDesactivateWidgetState createState() =>
      _ActivateDesactivateWidgetState();
}

class _ActivateDesactivateWidgetState extends State<ActivateDesactivateWidget> {
  @override
  Widget build(BuildContext context) {
    final userProvider = context.read<UserProvider>();

    return TextButton(
      onPressed: () async {
        await userProvider.editActivation(widget.user.id, widget.user.actived!);
        setState(() {
          widget.user.actived =
              !widget.user.actived!; // alterna entre activado / desactivado
        });
      },
      child: Text(
        widget.user.actived! ? "Desactivar" : "Activar",
        style: TextStyle(
          color: widget.user.actived!
              ? const Color.fromARGB(255, 255, 17, 0)
              : const Color.fromARGB(255, 0, 255, 8),
        ),
      ),
    );
  }
}
