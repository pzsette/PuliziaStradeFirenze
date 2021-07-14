import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:pulizia_strade/CustomWidgets/ParkingCard.dart';
import 'package:pulizia_strade/Models/PositionInMap.dart';
import 'package:pulizia_strade/Providers/ParkProvider.dart';
import 'package:pulizia_strade/Repository/shared_preferences.dart';
import 'package:pulizia_strade/Utils/NavigationUtils.dart';
import 'package:pulizia_strade/Utils/SizeConfig.dart';

Padding buildSpeedDial(context, GoogleMapController controller) {
  ParkProvider parkProvider = Provider.of<ParkProvider>(context);
  return Padding(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: SpeedDial(
        icon: Icons.local_parking,
        iconTheme: IconThemeData(color: Colors.white, size: 30),
        buttonSize: SizeConfig.blockSizeHorizontal * 17,
        visible: true,
        direction: SpeedDialDirection.Down,
        switchLabelPosition: true,
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.3,
        backgroundColor: Colors.blue[400],
        foregroundColor: Colors.black,
        childrenButtonSize: 60,
        childMargin: EdgeInsets.fromLTRB(0, 20, 20, 20),
        elevation: 15.0,
        shape: CircleBorder(side: BorderSide(color: Colors.white, width: 2.5)),
        children: [
          SpeedDialChild(
            child: Icon(Icons.info_outline),
            backgroundColor: Colors.white,
            label: 'Info parcheggio',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              _showParkingDialog(sharedPrefs.getParkPosition(), context);
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.center_focus_strong_outlined),
            backgroundColor: Colors.white,
            label: 'Trova',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              List coords = sharedPrefs.getParkCoords();
              controller.moveCamera(
                  CameraUpdate.newLatLng(LatLng(coords[0], coords[1])));
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.subdirectory_arrow_right),
            backgroundColor: Colors.white,
            label: 'Indicazioni',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              List coords = sharedPrefs.getParkCoords();
              openNavigatorTo(coords[0], coords[1], context);
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.delete),
            backgroundColor: Colors.red,
            label: 'Cancella',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () => parkProvider.removePark(),
          ),
        ],
      ));
}

void _showParkingDialog(PositionInMap position, context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return Container(height: 500, child: ParkingCard(position));
    },
  );
}
