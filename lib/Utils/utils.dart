import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';

convertDate(String date) {
  List<String> splitted = date.split("-");
  String month = "Null";
  switch (splitted[1]) {
    case ('01'):
      month = 'Gennaio';
      break;
    case ('02'):
      month = 'Febbraio';
      break;
    case ('03'):
      month = 'Marzo';
      break;
    case ('04'):
      month = 'Aprile';
      break;
    case ('05'):
      month = 'Maggio';
      break;
    case ('06'):
      month = 'Giugno';
      break;
    case ('07'):
      month = 'Luglio';
      break;
    case ('08'):
      month = 'Agosto';
      break;
    case ('09'):
      month = 'Settembre';
      break;
    case ('10'):
      month = 'Ottobre';
      break;
    case ('11'):
      month = 'Novembre';
      break;
    case ('12'):
      month = 'Dicembre';
      break;
  }
  String formattedDate = splitted[2] + " " + month + " " + splitted[0];
  return formattedDate;
}

changeMapMode(GoogleMapController mapController) async {
  String mapStyle = await getJsonFile("assets/mapTheme.txt");
  setMapStyle(mapStyle, mapController);
}

Future<String> getJsonFile(String path) async {
  return await rootBundle.loadString(path);
}

void setMapStyle(String mapStyle, GoogleMapController mapController) {
  mapController.setMapStyle(mapStyle);
}
