import 'package:flutter/material.dart';

class CircularButtom extends StatelessWidget {
  final double size;
  final double padding;
  final Color color;
  final IconData icon;
  final Function onClick;
  final Color backgroundColor;

  CircularButtom(
      {this.size,
      this.padding,
      this.color,
      this.backgroundColor = Colors.white,
      this.icon,
      this.onClick});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 10,
          side: BorderSide(width: 3.5, color: this.color),
          shape: CircleBorder(),
          primary: this.backgroundColor,
        ),
        onPressed: onClick,
        child: Padding(
          padding: EdgeInsets.all(this.padding),
          child: Icon(
            this.icon,
            size: this.size,
            color: this.color,
          ),
        ));
  }
}
