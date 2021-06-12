import 'package:firebase_messaging/firebase_messaging.dart';

class FireMessaging {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  void addFavourites(String streetName, String section) {
    String addressRevisited = streetName
        .toUpperCase()
        .split(" ")
        .join("-")
        .replaceAll("'", "")
        .replaceAll("(", "")
        .replaceAll(")", "");
    String tractRevisited = section
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
    _firebaseMessaging
        .subscribeToTopic(addressRevisited + "-" + tractRevisited);
  }

  void addParked(String streetName, String section) {
    String addressRevisited = streetName
        .toUpperCase()
        .split(" ")
        .join("-")
        .replaceAll("'", "")
        .replaceAll("(", "")
        .replaceAll(")", "");
    String tractRevisited = section
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
    _firebaseMessaging.subscribeToTopic(
        addressRevisited + "-" + tractRevisited + "-PARCHEGGIO");
  }

  void removeFavourites(String streetName, String section) {
    String addressRevisited = streetName
        .toUpperCase()
        .split(" ")
        .join("-")
        .replaceAll("'", "")
        .replaceAll("(", "")
        .replaceAll(")", "");
    String tractRevisited = section
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
    _firebaseMessaging
        .unsubscribeFromTopic(addressRevisited + "-" + tractRevisited);
  }

  void removeParked(String streetName, String section) {
    _firebaseMessaging
        .unsubscribeFromTopic(streetName + "-" + section + "-PARCHEGGIO");
  }
}
