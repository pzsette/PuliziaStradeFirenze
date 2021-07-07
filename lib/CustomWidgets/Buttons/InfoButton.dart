import 'package:flutter/material.dart';
import 'package:pulizia_strade/Utils/SizeConfig.dart';

class InfoButton extends StatelessWidget {
  final double size = SizeConfig.blockSizeHorizontal * 17;
  final Color color = Colors.white;
  final IconData icon = Icons.info_sharp;
  final Function onClick;
  final Color backgroundColor = Colors.blue[400];

  InfoButton({this.onClick});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 20,
        shape: CircleBorder(),
        primary: this.backgroundColor,
      ),
      onPressed: onClick,
      child: Icon(
        this.icon,
        size: this.size,
        color: this.color,
      ),
    );
  }
}
