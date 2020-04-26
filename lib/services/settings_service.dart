import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

String notificationsString = 'notificationsSetting';
bool notificationsDefault = false;

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

    return settings;
  }

  set notifications(bool value) {
    _sharedPreferences.then((onValue) {
      onValue.setBool(notificationsString, value);
    });
  }

  resetSettings() {
    _sharedPreferences.then((onValue) {
      onValue.setBool(notificationsString, notificationsDefault);
    });
  }
}

class Settings {
  bool notifications;
}
