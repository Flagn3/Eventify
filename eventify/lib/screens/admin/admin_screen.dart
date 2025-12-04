import 'package:eventify/models/user.dart';
import 'package:eventify/screens/admin/edit_user_screen.dart';
import 'package:eventify/screens/login/login_screen.dart';
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
    final parentContext = context;
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

          
          startActionPane: ActionPane(
            motion: ScrollMotion(),
            children: [

              // Activate / Deactivate
              SlidableAction(
                onPressed: (_) async {
                  await userProvider.editActivation(user.id, user.actived!);
                  setState(() {
                    user.actived = !user.actived!;
                  });
                  ScaffoldMessenger.of(parentContext).showSnackBar(
                    SnackBar(
                      content: Text(
                        user.actived! ? 'Usuario activado con éxito' : 'Usuario desactivado con éxito',
                      ),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                
                backgroundColor: user.actived! ? Colors.red : Colors.green,
                foregroundColor: Colors.white,
                icon: user.actived! ? Icons.toggle_off : Icons.toggle_on,
                label: user.actived! ? "Desactivar" : "Activar",
              ),

              // Edit
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

          // Delete
          endActionPane: ActionPane(
            motion: ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) async {
                  // show confirmation
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
                    ScaffoldMessenger.of(parentContext).showSnackBar(
                      SnackBar(content: Text('Usuario eliminado con éxito'),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                      )
                    );
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
            trailing: SizedBox(
              width: MediaQuery.of(context).size.width * 0.2,
              child: Text(user.actived == true ? 'Activado' : 'Desactivado', 
                style: TextStyle(
                  color: user.actived == true ? const Color.fromARGB(255, 0, 255, 8) : const Color.fromARGB(255, 255, 17, 0),
                  fontWeight: FontWeight.bold
                ),
              ),
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


