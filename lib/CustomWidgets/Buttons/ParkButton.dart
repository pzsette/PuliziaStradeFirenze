import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulizia_strade/Models/PositionInMap.dart';
import 'package:pulizia_strade/Providers/ParkProvider.dart';

class ParkButton extends StatelessWidget {
  final PositionInMap position;
  final double latitude;
  final double longitude;
  final bool positionFoundInDb;
  final String alertMessage =
      "Attenzione la posizione attuale non è comprese tra quelle monitorate dalla nostra app. Il parcheggio è stato salvato, ma non riceverai alcuna notifica su una eventuale pulizia delle strade.";

  ParkButton(
      this.position, this.latitude, this.longitude, this.positionFoundInDb);

  @override
  Widget build(BuildContext context) {
    ParkProvider parkProvider = Provider.of<ParkProvider>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
        child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue[400]),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ))),
            onPressed: () async {
              parkProvider.addPark(
                  position, latitude, longitude, positionFoundInDb);
            },
            child: Padding(
                padding: EdgeInsets.all(screenWidth / 42),
                child: Text("Parcheggia qui",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth / 21,
                        fontWeight: FontWeight.w500)))));
  }
}
