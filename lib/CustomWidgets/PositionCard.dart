import 'package:flutter/material.dart';
import 'package:pulizia_strade/CustomWidgets/Buttons/FavouriteButtons.dart';
import 'package:pulizia_strade/CustomWidgets/Buttons/CancelButton.dart';
import 'package:pulizia_strade/CustomWidgets/Labels/DateLabel.dart';
import 'package:pulizia_strade/CustomWidgets/Labels/PositionLabel.dart';
import 'package:pulizia_strade/Models/PositionInMap.dart';
import 'package:pulizia_strade/Network/dioNetwork.dart';
import 'package:pulizia_strade/Repository/favourites_db.dart';
import 'package:pulizia_strade/Utils/SizeConfig.dart';

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
                            EdgeInsets.all(SizeConfig.blockSizeHorizontal * 3),
                        child: PositionLabel(position)),
                    Padding(
                        padding: EdgeInsets.all(
                            SizeConfig.blockSizeHorizontal * 1.5),
                        child: DateLabel(position, snapshot.data[0])),
                    Row(
                      children: [
                        if (snapshot.data[0]["data"] != "indirizzo non trovato")
                          Padding(
                              padding: EdgeInsets.fromLTRB(
                                  0,
                                  SizeConfig.blockSizeVertical * 1.5,
                                  0,
                                  SizeConfig.blockSizeHorizontal * 3),
                              child:
                                  FavouriteButton(position, snapshot.data[1])),
                        Padding(
                            padding: EdgeInsets.all(
                                SizeConfig.blockSizeVertical * 1),
                            child: CancelButton())
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    ),
                  ],
                ),
              );
            }
            return result;
          }),
    );
  }
}
