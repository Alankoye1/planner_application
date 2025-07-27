import 'package:flutter/material.dart';

class CustomScrollable extends StatelessWidget {
  const CustomScrollable({
    super.key,
    required this.labelText,
    required this.controller,
  });

  final String labelText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      child: TextField(
        decoration: InputDecoration(labelText: labelText),
        keyboardType: TextInputType.number,
        controller: controller,
        textInputAction: TextInputAction.next,
      ),
    );
  }
}