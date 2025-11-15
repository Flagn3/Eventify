import 'package:eventify/providers/user_provider.dart';
import 'package:eventify/screens/admin_screen.dart';
import 'package:eventify/screens/register_screen.dart';
import 'package:eventify/screens/test_screen.dart';
import 'package:eventify/widgets/screens/text_and_password_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Lockear orientación vertical
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    // Permitir rotación nuevamente al salir de esta pantalla
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE53DB2), Color(0xFF3C4869)],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.08,
            vertical: size.height * 0.1,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Imagen superior
              SizedBox(
                height: size.height * 0.4,
                child: Image.asset(
                  "assets/images/eventify_logo.png",
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 0),

              // Email
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: FieldWidget(
                  hintText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  controller: emailController, //controller
                ),
              ),
              const SizedBox(height: 20),

              // Contraseña
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                child: PasswordWidget(
                  hintText: 'Contraseña',
                  obscureText: true,
                  controller: passwordController, //controller
                ),
              ),
              const SizedBox(height: 40),

              // Botón de Login
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  //onPressed
                  onPressed: () async {
                    final userProvider = context.read<UserProvider>();
                    await userProvider.login(
                      emailController.text,
                      passwordController.text,
                    );

                    final user = userProvider.activeUser;

                    if (user != null) {
                      if (user.role == 'u' || user.role == 'o') {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) =>
                                TestScreen(), //screen vacia de momento
                          ),
                        );
                      } else if (user.role == 'a') {
                        //redirect a admin view
                        print('admin redirect');
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => AdminScreen(),
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(userProvider.errorMessage!)),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF33BE86),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Texto de registro
              const Text(
                '¿Aún no tienes cuenta?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),

              // Botón para ir a registro
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Registerscreen(),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF33BE86), width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 14,
                  ),
                ),
                child: const Text(
                  'Registrarse',
                  style: TextStyle(
                    color: Color(0xFF33BE86),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
