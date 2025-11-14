import 'package:eventify/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:eventify/widgets/screens/text_and_password_field.dart';
import 'package:eventify/widgets/screens/login_screen_button.dart';

class Registerscreen extends StatefulWidget {
  const Registerscreen({super.key});

  @override
  State<Registerscreen> createState() => _RegisterscreenState();
}

class _RegisterscreenState extends State<Registerscreen> {


  @override
  Widget build(BuildContext context) {

    final textFieldWidth = MediaQuery.of(context).size.width*0.8;
    String dropdownValue = 'Usuario';
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
            
            /*
              Button to return to the login view
              And 'Crea tu cuenta' text
            */
            Row(
              children: [
                SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                IconButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                }, icon: Icon(Icons.arrow_back_rounded, size: 35)),
                SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                Text("Crea tu cuenta", style: TextStyle(
                  fontSize: 40,
                  color: Colors.white
                ),)
              ],
            ),

            //Name textfield
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: SizedBox(
                        width: textFieldWidth,
                        child: FieldWidget(
                          hintText: "Nombre", 
                          prefixIcon: Icon(Icons.person)
                        )
                      )
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),

                    //Email
                    Center(
                      child: SizedBox(
                        width: textFieldWidth,
                        child: FieldWidget(
                          hintText: "Email", 
                          prefixIcon: Icon(Icons.email)
                        )
                      )
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),

                    //Password
                    Center(
                      child: SizedBox(
                        width: textFieldWidth,
                        child: PasswordWidget(
                          hintText: "Contraseña", 
                          obscureText: true,)
                      )
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),

                    //Confirm password
                    Center(
                      child: SizedBox(
                        width: textFieldWidth,
                        child: PasswordWidget(
                          hintText: "Confirmar contraseña", 
                          obscureText: true,
                          )
                      )
                    ),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),

                    //Roles
                    Center(
                      child: SizedBox(
                        width: textFieldWidth,
                        child: DropdownButtonFormField<String>(
                          initialValue: dropdownValue,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          items: <String>['Usuario', 'Organizador']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(), 
                          onChanged: (String? newValue){
                            setState(() {
                              dropdownValue = newValue!;
                            });
                          }),
                      ),
                    ),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),

                    Center(
                      child: SizedBox(
                        width: textFieldWidth,
                        child: RegisterButton(text: 'Registrarse'),
                      ),
                    )
                  ],
                ),
              ), 
            )
          ],
        )
      ),
    );
  }
}