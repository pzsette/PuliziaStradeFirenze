import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pulizia_strade/Models/PositionInMap.dart';
import '../Repository/shared_preferences.dart';

class ParkProvider with ChangeNotifier {
  Set<Marker> _markers = {};
  bool _parked;
  //FireMessaging fireMessaging = new FireMessaging();

  ParkProvider() {
    _parked = sharedPrefs.isParked();
    if (_parked) {
      _addMarker(
          sharedPrefs.getParkCoords()[0], sharedPrefs.getParkCoords()[1]);
    }
  }

  get ui => null;

  void addPark(PositionInMap position, double latitude, double longitude,
      bool positionFoundInDB) {
    if (positionFoundInDB) {
      //fireMessaging.addParked(position.streetName, position.section);
    }
    sharedPrefs.setPark(latitude, longitude);
    sharedPrefs.setParkSteerName(position.streetName);
    String section = positionFoundInDB ? position.section : "noSection";
    sharedPrefs.setParkStreetSection(section);
    _addMarker(latitude, longitude);
    _parked = true;
    notifyListeners();
  }

  void removePark() {
    //fireMessaging.removeParked(
    //sharedPrefs.getParkStreetName(), sharedPrefs.getParkStreetSection());
    sharedPrefs.deletePark();
    sharedPrefs.removeKey("parkingStreetName");
    sharedPrefs.removeKey("parkingStreetSection");
    _parked = false;
    markers.clear();
    notifyListeners();
  }

  Set<Marker> get markers => _markers;
  bool get parked => _parked;

  void _addMarker(double lat, double long) async {
    final Marker marker = Marker(
      markerId: MarkerId("Parcheggio"),
      position: LatLng(lat, long),
      icon: await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(devicePixelRatio: 4), 'assets/parkIcon.png'),
    );
    markers.add(marker);
  }
}
