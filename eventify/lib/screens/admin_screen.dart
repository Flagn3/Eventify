import 'package:eventify/models/user.dart';
import 'package:eventify/screens/edit_user_screen.dart';
import 'package:eventify/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:eventify/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';


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
          return Slidable(
            key: ValueKey(user.id),

          // --- ACCIONES IZQUIERDA (activar/desactivar y editar) ---
          startActionPane: ActionPane(
            motion: ScrollMotion(),
            children: [

              // Activar / Desactivar
              SlidableAction(
                onPressed: (context) async {
                  await userProvider.editActivation(user.id, user.actived!);
                  setState(() {
                    user.actived = !user.actived!;
                  });
                },
                backgroundColor: user.actived! ? Colors.red : Colors.green,
                foregroundColor: Colors.white,
                icon: user.actived! ? Icons.toggle_off : Icons.toggle_on,
                label: user.actived! ? "Desactivar" : "Activar",
              ),

              // Editar
              SlidableAction(
                onPressed: (context) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditUserScreen(user: user),
                    ),
                  );
                },
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                icon: Icons.edit,
                label: "Editar",
              ),
            ],
          ),

          // --- ACCIÓN DERECHA (eliminar) ---
          endActionPane: ActionPane(
            motion: ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) async {
                  // Mostrar confirmación
                  final confirm = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Confirmar eliminación"),
                      content: Text("¿Deseas eliminar este usuario?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text("Cancelar"),
                        ),
                        TextButton(
                          onPressed: () async {
                            await userProvider.deleteUser(user.id);
                            Navigator.pop(context, true);
                          },
                          child: Text("Eliminar", style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    await userProvider.deleteUser(user.id);
                    await userProvider.getUsers();
                  }
                },
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: "Eliminar",
              ),
            ],
          ),

          // List Tile 
          child: ListTile(
            title: Text(user.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.email ?? ""),
                Text(user.role == 'u' ? 'Usuario' : 'Organizador'),
              ],
            ),
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
