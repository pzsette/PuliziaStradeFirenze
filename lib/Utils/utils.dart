import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';

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
