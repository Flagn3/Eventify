import 'package:flutter/material.dart';
import 'package:eventify/widgets/screens/widgets.dart';

class Registerscreen extends StatefulWidget {
  const Registerscreen({super.key});

  @override
  State<Registerscreen> createState() => _RegisterscreenState();
}

class _RegisterscreenState extends State<Registerscreen> {


  @override
  Widget build(BuildContext context) {
    final textFieldWidth = MediaQuery.of(context).size.width*0.8;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter, 
            colors: [
              Color(0xFFE35EB3),
              Color(0xFF3C4969)
            ]
            )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
            Row(
              children: [
                SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                Icon(Icons.arrow_back_rounded, size: 40),
                SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                Text("Crea tu cuenta", style: TextStyle(
                  fontSize: 40,
                  color: Colors.white
                ),)
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(8),
                children: [
                  Center(
                    child: SizedBox(
                      width: textFieldWidth,
                      child: FieldWidget(hintText: "Email",)
                    )
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Center(
                    child: SizedBox(
                      width: textFieldWidth,
                      child: PasswordWidget(
                        hintText: "Contraseña", 
                        obscureText: true,)
                    )
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Center(
                    child: SizedBox(
                      width: textFieldWidth,
                      child: PasswordWidget(
                        hintText: "Confirmar contraseña", 
                        obscureText: true,
                        )
                    )
                  ),
                ],
              ), 
            )
          ],
        )
      ),
    );
  }
}