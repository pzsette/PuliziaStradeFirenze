import 'package:pulizia_strade/Models/SettingsValues.dart';
import 'package:pulizia_strade/Utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceManager {
  static SharedPreferences _sharedPrefs;

  init() async {
    if (_sharedPrefs == null) {
      _sharedPrefs = await SharedPreferences.getInstance();
    }
  }

  void removeKey(String key) {
    _sharedPrefs.remove(key);
  }

  void setPark(double lat, double long) {
    _sharedPrefs.setBool(parked, true);
    _sharedPrefs.setDouble(parkLat, lat);
    _sharedPrefs.setDouble(parkLong, long);
  }

  void setParkSteerName(String name) {
    String addressRevisited = name
        .toUpperCase()
        .split(" ")
        .join("-")
        .replaceAll("'", "")
        .replaceAll("(", "")
        .replaceAll(")", "");
    _sharedPrefs.setString(parkSteetName, addressRevisited);
  }

  void setParkStreetSection(String name) {
    String tractRevisited = name
        .toUpperCase()
        .split(" ")
        .join("-")
        .replaceAll("'", "")
        .replaceAll("(", "")
        .replaceAll(")", "")
        .replaceAll("[", "")
        .replaceAll("]", "")
        .replaceAll("/", "_")
        .replaceAll(",", "");
    _sharedPrefs.setString(parkStreetSection, tractRevisited);
  }

  void setNotificationTimeOption(NotificationTimeOptions value) {
    _sharedPrefs.setString(notificationTimeOption, value.toString());
  }

  void deletePark() {
    _sharedPrefs.setBool(parked, false);
  }

  bool isParked() {
    return _sharedPrefs.containsKey(parked)
        ? _sharedPrefs.getBool(parked)
        : false;
  }

  List getParkCoords() {
    double latitude = _sharedPrefs.getDouble(parkLat);
    double longitude = _sharedPrefs.getDouble(parkLong);
    return [latitude, longitude];
  }

  String getParkStreetName() {
    return _sharedPrefs.getString(parkSteetName);
  }

  String getParkStreetSection() {
    return _sharedPrefs.getString(parkStreetSection);
  }

  NotificationTimeOptions getNotificationTimeOption() {
    return convertStringToNotificationTimeVlaue(
        _sharedPrefs.getString(notificationTimeOption));
  }
}

final sharedPrefs = SharedPreferenceManager();
const String parked = "parkIsSaved";
const String parkLat = "latitudeOfPark";
const String parkLong = "longitudeOfPark";
const String parkSteetName = "parkingStreetName";
const String parkStreetSection = "parkingStreetSection";
const String notificationTimeOption = "notTimeOption";
