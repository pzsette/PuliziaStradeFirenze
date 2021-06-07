import 'package:flutter/material.dart';
import 'package:pulizia_strade/CustomWidgets/Buttons/FavouriteButtons.dart';
import 'package:pulizia_strade/CustomWidgets/Labels/DateLabel.dart';
import 'package:pulizia_strade/CustomWidgets/Labels/PositionLabel.dart';
import 'package:pulizia_strade/Models/PositionInMap.dart';
import 'package:pulizia_strade/Network/dioNetwork.dart';
import 'package:pulizia_strade/Repository/repository_db.dart';

class PositionCard extends StatelessWidget {
  final PositionInMap position;
  final DioNetwork dio = new DioNetwork();

  PositionCard(this.position);

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
            DBHelper.instance.checkIfPositionInFavourite(position)
          ]),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            Widget result;
            if (snapshot == null ||
                snapshot.connectionState == ConnectionState.waiting) {
              result = Container(
                  height: MediaQuery.of(context).size.height * 0.35,
                  child: Center(
                      child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    strokeWidth: 3.0,
                  )));
            } else {
              double screenWidth = MediaQuery.of(context).size.width;
              result = Container(
                //padding: EdgeInsets.all(screenWidth / ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.fromLTRB(
                            screenWidth / 42,
                            screenWidth / 42,
                            screenWidth / 42,
                            screenWidth / 42),
                        child: PositionLabel(position)),
                    Padding(
                        padding: EdgeInsets.fromLTRB(
                            screenWidth / 42,
                            screenWidth / 42,
                            screenWidth / 42,
                            screenWidth / 42),
                        child: DateLabel(position, snapshot.data[0])),
                    if (snapshot.data[0]["data"] != "indirizzo non trovato")
                      Padding(
                          padding: EdgeInsets.fromLTRB(
                              0, screenWidth / 42, 0, screenWidth / 42),
                          child: FavouriteButton(position, snapshot.data[1])),
                  ],
                ),
              );
            }
            return result;
          }),
    );
  }
}
