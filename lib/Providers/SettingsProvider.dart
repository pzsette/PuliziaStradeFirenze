import 'package:flutter/material.dart';
import 'package:pulizia_strade/Models/SettingsValues.dart';
import 'package:pulizia_strade/Repository/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  NotificationTimeOptions _selectedValue;
  SettingsProvider() {
    _selectedValue = sharedPrefs.getNotificationTimeOption();
  }

  void changeNotificationHours(NotificationTimeOptions value) {
    _selectedValue = value;
    sharedPrefs.setNotificationTimeOption(value);
    notifyListeners();
  }

  NotificationTimeOptions get selectedValue => _selectedValue;
}
