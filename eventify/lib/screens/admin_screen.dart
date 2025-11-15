import 'package:flutter/material.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de usuarios"),
        backgroundColor: Color(0xFFE35EB3),
        actions: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(right: MediaQuery.of(context).size.width*0.08),
                child: Text(
                  "Logout",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
            ),
          )
        ],
      ),
      body: ListView.separated(
        itemCount: 20,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text("Nombre"),
            subtitle: Text("Correo@gmail.com"),
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
                ActivateDesactivateWidget(),
                IconButton(
                  onPressed: (){}, 
                  icon: Icon(Icons.edit)
                ),
                IconButton(
                  onPressed: (){}, 
                  icon: Icon(Icons.delete)
                )
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
  const ActivateDesactivateWidget({super.key});

  @override
  _ActivateDesactivateWidgetState createState() =>
      _ActivateDesactivateWidgetState();
}

class _ActivateDesactivateWidgetState
    extends State<ActivateDesactivateWidget> {
  bool activo = false; // estado inicial

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        setState(() {
          activo = !activo; // alterna entre activado / desactivado
        });
      },
      child: Text(
        activo ? "Desactivar" : "Activar",
        style: TextStyle(
          color: activo ? const Color.fromARGB(255, 255, 17, 0) : const Color.fromARGB(255, 0, 255, 8),
        ),
      ),
    );
  }
}