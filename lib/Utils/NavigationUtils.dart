import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openNavigatorTo(double latitude, double longitude, context) async {
  if (Platform.isIOS) {
    showCupertinoModalPopup(
        context: context,
        builder: (context) => directionSheet(latitude, longitude, context));
    //String url= 'https://maps.apple.com/?q=$latitude,$longitude';
  } else {
    String url = Uri.encodeFull(
        'https://www.google.com/maps/dir/?api=1&destination=' +
            latitude.toString() +
            ',' +
            longitude.toString() +
            '&travelmode=walking');
    launchUrl(url);
  }
}

launchUrl(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

CupertinoActionSheet directionSheet(
    double latitude, double longitude, context) {
  return CupertinoActionSheet(
      message: Text('Selezionare l\'applicazione per navigare'),
      actions: [
        CupertinoActionSheetAction(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Container(
                child: new Image.asset(
                  'assets/appleMapsLogo.png',
                  height: 30.0,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 30, width: 15),
              Text("Mappe"),
            ],
          ),
          onPressed: () {
            String url = Uri.encodeFull('http://maps.apple.com/?daddr=' +
                latitude.toString() +
                ',' +
                longitude.toString() +
                '&dirflg=w');
            Navigator.pop(context);
            launch(url);
          },
        ),
        CupertinoActionSheetAction(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Container(
                child: new Image.asset(
                  'assets/googleMapsLogo.png',
                  height: 30.0,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 30, width: 15),
              Text("Google Maps"),
            ],
          ),
          onPressed: () {
            String url = Uri.encodeFull(
                'https://www.google.com/maps/dir/?api=1&destination=' +
                    latitude.toString() +
                    ',' +
                    longitude.toString() +
                    '&travelmode=walking');
            Navigator.pop(context);
            launchUrl(url);
          },
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
          child: Text("Annulla"),
          onPressed: () {
            Navigator.pop(context);
          }));
}
