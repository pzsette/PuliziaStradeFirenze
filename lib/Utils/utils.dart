import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'package:pulizia_strade/Models/SettingsValues.dart';

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

String convertNotificationTimeValueToString(NotificationTimeOptions value) {
  if (value == NotificationTimeOptions.one_day) {
    return "1 giorno prima";
  } else if (value == NotificationTimeOptions.twelve_hours) {
    return "12 ore prima";
  } else if (value == NotificationTimeOptions.six_hours) {
    return "6 ore prima";
  } else {
    return "2 ore prima";
  }
}

NotificationTimeOptions convertStringToNotificationTimeVlaue(String value) {
  switch (value) {
    case "NotificationTimeOptions.one_day":
      return NotificationTimeOptions.one_day;
      break;

    case "NotificationTimeOptions.twelve_hours":
      return NotificationTimeOptions.twelve_hours;
      break;

    case "NotificationTimeOptions.six_hours":
      return NotificationTimeOptions.six_hours;
      break;

    case "NotificationTimeOptions.two_hours":
      return NotificationTimeOptions.two_hours;
      break;

    default:
      return NotificationTimeOptions.one_day;
  }
}
