// import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

class CustomButtons extends StatelessWidget {
  final String title;
  final void Function() onPressed;
  const CustomButtons({
    super.key,
    required this.onPressed,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 45,
      color: Colors.blue[600],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      onPressed: onPressed,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
