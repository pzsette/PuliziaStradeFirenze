import 'package:flutter/material.dart';
import 'package:pulizia_strade/Utils/SizeConfig.dart';

class NoInternet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/error.gif",
                height: SizeConfig.blockSizeVertical * 10,
                width: SizeConfig.blockSizeHorizontal * 25),
            SizedBox(height: SizeConfig.blockSizeHorizontal * 3),
            Text(
              "Connessione a internet assente",
              style: TextStyle(
                  fontSize: SizeConfig.blockSizeHorizontal * 5,
                  fontWeight: FontWeight.bold,
                  color: Colors.red),
            ),
          ],
        )));
  }
}
