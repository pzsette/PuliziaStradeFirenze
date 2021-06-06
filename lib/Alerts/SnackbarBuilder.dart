import 'package:flutter/material.dart';

class SnackbarBuilder {
  static build(String message, Color snackbarColor) {
    return SnackBar(
        elevation: 6.0,
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        content: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: Colors.white,
            ),
            SizedBox(width: 5),
            Text(
              message,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ));
  }
}
