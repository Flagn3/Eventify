import 'package:flutter/material.dart';

// Widget for the password textfield
class PasswordWidget extends StatefulWidget {
  final String hintText;
  final bool obscureText;

  const PasswordWidget({
    super.key,
    required this.hintText,
    required this.obscureText
  });

  @override
  PasswordWidgetState createState() => PasswordWidgetState();
}

class PasswordWidgetState extends State<PasswordWidget> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: _obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock),
        border: InputBorder.none,
        hintText: widget.hintText,
        filled: true,
        fillColor: Colors.white,
        suffixIcon: IconButton(
          icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
    );
  }
}

class FieldWidget extends StatelessWidget {
  const FieldWidget({
    super.key,
    required String hintText,
  }) : _hintText = hintText;

  final String _hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.mail),
        hintText: _hintText,
        filled: true,
        fillColor: Colors.white,
        border: InputBorder.none
      ),
    );
  }
}