import 'package:flutter/material.dart';

// Widget for the password textfield
class PasswordWidget extends StatefulWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController? controller;

  const PasswordWidget({
    super.key,
    required this.hintText,
    required this.obscureText,
    this.controller
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
      controller: widget.controller,  
      obscureText: _obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none
        ),
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
    required Icon prefixIcon,
    this.controller
  }) : _hintText = hintText, _prefixIcon = prefixIcon;

  final String _hintText;
  final Icon _prefixIcon;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        prefixIcon: _prefixIcon,
        hintText: _hintText,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none
        ),
      ),
    );
  }
}