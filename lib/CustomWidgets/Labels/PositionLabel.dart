import 'package:flutter/material.dart';
import 'package:pulizia_strade/Models/PositionInMap.dart';
import 'package:pulizia_strade/Utils/SizeConfig.dart';

class PositionLabel extends StatelessWidget {
  final PositionInMap position;

  PositionLabel(this.position);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            position.streetName,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black,
                fontSize: SizeConfig.blockSizeVertical * 2.7,
                fontWeight: FontWeight.w500),
          ),
          if (position.section != 'strada completa' && position.section != null)
            Text(position.section,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: SizeConfig.blockSizeVertical * 2.3,
                )),
        ],
      ),
    );
  }
}
