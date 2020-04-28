import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

String notificationsString = 'notificationsSetting';
bool notificationsDefault = true;

String testTimeBlockingString = 'testTimeBlockingSetting';
bool testTimeBlockingDefault = true;

class SettingsService {
  SettingsService._() {
    _sharedPreferences = SharedPreferences.getInstance();
  }

  static final SettingsService _instance = SettingsService._();

  factory SettingsService() {
    return _instance;
  }

  Future<SharedPreferences> _sharedPreferences;

  Future<Settings> get settings async {
    var settings = Settings();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    settings.notifications =
        (prefs.getBool(notificationsString) ?? notificationsDefault);

    settings.testTimeBlocking =
        (prefs.getBool(testTimeBlockingString) ?? testTimeBlockingDefault);

    return settings;
  }

  set notifications(bool value) {
    _sharedPreferences.then((onValue) {
      onValue.setBool(notificationsString, value);
    });
  }

  set testTimeBlocking(bool value) {
    _sharedPreferences.then((onValue) {
      onValue.setBool(testTimeBlockingString, value);
    });
  }

  Future<bool> getTestTimeBlocking() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return (prefs.getBool(notificationsString) ?? notificationsDefault);
  }

  Future<bool> getNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return (prefs.getBool(notificationsString) ?? notificationsDefault);
  }

  resetSettings() {
    _sharedPreferences.then((onValue) {
      onValue.setBool(notificationsString, notificationsDefault);
      onValue.setBool(testTimeBlockingString, testTimeBlockingDefault);
    });
  }
}

class Settings {
  bool notifications;
  bool testTimeBlocking;
}
