import 'package:flutter/material.dart';

class CommonWidget {
  static ButtonStyle primaryButtonStyle() {
    return ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  static IconButton commonIconButton({
    required VoidCallback onPressed,
    required IconData icon,
    double size = 20.0,
    EdgeInsets padding = const EdgeInsets.all(8.0),
    Color backgroundColor = Colors.blue,
    Color iconColor = Colors.white,
  }) {
    return IconButton(
      onPressed: onPressed,
      color: iconColor,
      icon: Icon(icon),
      iconSize: size,
      padding: padding,
    );
  }

  static InputDecoration inputStyle(
      {String? placeholder, required String hintText}) {
    return InputDecoration(
      hintText: placeholder,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  static TextStyle titleText() {
    return const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );
  }
}
