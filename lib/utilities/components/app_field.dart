import 'package:flutter/material.dart';

class AppField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool autocorrect;
  final Function(String)? onChanged;

  const AppField({
    Key? key,
    required this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.autocorrect = false,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55, // Fixed height for the TextField
      color: Colors.white, // Set background color to white
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.black),
        keyboardType: keyboardType,
        autocorrect: autocorrect,
        onChanged: onChanged,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: hintText,
        ),
      ),
    );
  }
}
