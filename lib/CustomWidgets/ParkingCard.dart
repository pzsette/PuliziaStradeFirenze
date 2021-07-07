import 'package:flutter/material.dart';
import 'package:pulizia_strade/CustomWidgets/Labels/DateLabel.dart';
import 'package:pulizia_strade/CustomWidgets/Labels/PositionLabel.dart';
import 'package:pulizia_strade/Models/PositionInMap.dart';
import 'package:pulizia_strade/Network/dioNetwork.dart';
import 'package:pulizia_strade/Utils/SizeConfig.dart';

class ParkingCard extends StatelessWidget {
  final PositionInMap position;
  final DioNetwork dio = new DioNetwork();

  ParkingCard(this.position);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: FutureBuilder(
          future: Future.wait([
            dio.getParkingInfoOnPosition(position),
          ]),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            Widget result;
            if (snapshot == null ||
                snapshot.connectionState == ConnectionState.waiting) {
              result = Container(
                  height: SizeConfig.blockSizeVertical * 20,
                  width: SizeConfig.blockSizeHorizontal * 20,
                  child: Center(
                      child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    strokeWidth: 3.0,
                  )));
            } else {
              result = Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                        padding:
                            EdgeInsets.all(SizeConfig.blockSizeVertical * 1),
                        child: Text(
                          "Hai parcheggia il tuo veicolo in :",
                          style: TextStyle(
                              fontSize: SizeConfig.blockSizeVertical * 2.2),
                        )),
                    Padding(
                        padding:
                            EdgeInsets.all(SizeConfig.blockSizeHorizontal * 3),
                        child: PositionLabel(position)),
                    Padding(
                        padding: EdgeInsets.all(
                            SizeConfig.blockSizeHorizontal * 1.5),
                        child: DateLabel(position, snapshot.data[0])),
                  ],
                ),
              );
            }
            return result;
          }),
    );
  }
}
