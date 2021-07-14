import 'package:flutter/material.dart';
import 'package:pulizia_strade/Models/PositionInMap.dart';
import 'package:pulizia_strade/Utils/SizeConfig.dart';
import 'package:pulizia_strade/Utils/utils.dart';

class DateLabel extends StatelessWidget {
  final PositionInMap position;
  final Map result;

  DateLabel(this.position, this.result);

  @override
  Widget build(BuildContext context) {
    print("result to string: " + result.toString());
    return Container(
        child: Column(
      children: [
        if (position.section != null &&
            result["data"] != "indirizzo non trovato")
          Text("Prossima pulizia:",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 2.3)),
        (position.section != null &&
                (result["data"] != "indirizzo non trovato"))
            ? Text(convertDate(result['data']) + " alle " + result['ora'],
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: SizeConfig.blockSizeVertical * 2.5,
                    fontWeight: FontWeight.w500))
            : Text(
                "Strada non presente nel database di pulizia strade",
                style: TextStyle(
                    fontSize: SizeConfig.blockSizeVertical * 2.3,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              )
      ],
    ));
  }
}
