import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:pulizia_strade/Models/PositionInMap.dart';

Future<List<double>> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  Position pos = await Geolocator.getCurrentPosition();
  double lat = pos.latitude;
  double long = pos.longitude;
  return [lat, long];
}

Future<PositionInMap> getPosition(double latitude, double longitude) async {
  //double lat = 43.780750;
  //double long = 11.244067;
  List<Placemark> placemark =
      await placemarkFromCoordinates(latitude, longitude);
  //List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(43.7705183, 11.24014); //borgo san frediano
  //List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(43.780750, 11.244067); //via guido monaco
  //List<Placemark> placemark = await Geolocator()
  //    .placemarkFromCoordinates(43.783155, 11.241620); // via cassia
  //List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(43.726838,11.322405); // via Antella
  //List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(43.760439,11.293287); // via fez
  String city = placemark[0].locality;
  String address = placemark[0].thoroughfare.toUpperCase();
  PositionInMap position = new PositionInMap(address, city);
  return position;
}
