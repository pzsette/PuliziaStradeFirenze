import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pulizia_strade/CustomWidgets/Buttons/FavouriteButtons.dart';
import 'package:pulizia_strade/CustomWidgets/Buttons/ParkButton.dart';
import 'package:pulizia_strade/CustomWidgets/Labels/DateLabel.dart';
import 'package:pulizia_strade/CustomWidgets/Labels/PositionLabel.dart';
import 'package:pulizia_strade/Models/PositionInMap.dart';
import 'package:pulizia_strade/Network/dioNetwork.dart';
import 'package:pulizia_strade/Repository/repository_db.dart';

class InfoBottomSheet extends StatefulWidget {
  final PositionInMap position;
  final double latitude;
  final double longitude;
  final DioNetwork dio = new DioNetwork();

  InfoBottomSheet(this.position, this.latitude, this.longitude);

  @override
  _InfoBottomSheetState createState() => _InfoBottomSheetState();
}

class _InfoBottomSheetState extends State<InfoBottomSheet> {
  String googleApiKey;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return FutureBuilder(
        future: Future.wait([
          widget.dio.getParkingInfoOnPosition(widget.position),
          DBHelper.instance.checkIfPositionInFavourite(widget.position)
        ]),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          Widget result;
          if (snapshot == null ||
              snapshot.connectionState == ConnectionState.waiting) {
            result = Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  color: Colors.white),
              height: MediaQuery.of(context).size.height * 0.30,
              child: Center(
                  child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                strokeWidth: 3.0,
              )),
            );
          } else {
            result = Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    color: Colors.white),
                child: SafeArea(
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                      /*Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.15 + 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20)),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: LocationHelper.getImageFromCoord(
                                    widget.latitude, widget.longitude))),
                      ),*/
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            0, screenWidth / 21, 0, screenWidth / 42),
                        child: PositionLabel(widget.position),
                      ),
                      Padding(
                          padding: EdgeInsets.fromLTRB(
                              0, screenWidth / 42, 0, screenWidth / 42),
                          child: DateLabel(widget.position, snapshot.data[0])),
                      Padding(
                          padding: EdgeInsets.fromLTRB(
                              0, screenWidth / 42, 0, screenWidth / 42),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              if (snapshot.data[0]["data"] !=
                                  "indirizzo non trovato")
                                FavouriteButton(
                                    widget.position, snapshot.data[1]),
                              ParkButton(
                                  widget.position,
                                  widget.latitude,
                                  widget.longitude,
                                  (snapshot.data[0]["data"] !=
                                          "indirizzo non trovato")
                                      ? true
                                      : false),
                            ],
                          ))
                    ])));
          }
          return result;
        });
  }

  showAlertDialog(BuildContext context, Text message) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text("Attenzione"),
      content: message,
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
