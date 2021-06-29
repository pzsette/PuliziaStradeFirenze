import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:pulizia_strade/Models/PositionInMap.dart';

Future<List<double>> getCoordinates() async {
  print("DEntrooo");
  LocationData locationData;
  Location location = new Location();
  locationData = await location.getLocation();
  double lat = locationData.latitude;
  double long = locationData.longitude;
  return [lat, long];
}

Future<PositionInMap> getPosition(double latitude, double longitude) async {
  //double lat = 43.780750;
  //double long = 11.244067;
  //List<Placemark> placemark =
  //await Geolocator().placemarkFromCoordinates(latitude, longitude);
  //List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(43.7705183, 11.24014); //borgo san frediano
  //List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(43.780750, 11.244067); //via guido monaco
  List<Placemark> placemark = await Geolocator()
      .placemarkFromCoordinates(43.783155, 11.241620); // via cassia
  //List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(43.726838,11.322405); // via Antella
  //List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(43.760439,11.293287); // via fez
  String city = placemark[0].locality;
  String address = placemark[0].thoroughfare.toUpperCase();
  PositionInMap position = new PositionInMap(address, city);
  return position;
}
