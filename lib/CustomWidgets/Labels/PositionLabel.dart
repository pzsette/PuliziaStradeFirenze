import 'package:flutter/material.dart';
import 'package:pulizia_strade/Models/PositionInMap.dart';

class PositionLabel extends StatelessWidget {
  final PositionInMap position;

  PositionLabel(this.position);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            position.streetName,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black,
                fontSize: screenWidth / 20,
                fontWeight: FontWeight.w500),
          ),
          if (position.section != 'strada completa' && position.section != null)
            Text(position.section,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: screenWidth / 25,
                )),
        ],
      ),
    );
  }
}
