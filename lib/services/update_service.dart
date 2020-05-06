import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

// const APP_STORE_URL = '';
// const PLAY_STORE_URL = 'www.google.pl';

class UpdateService {
  UpdateService._() {
    this._asked = false;
  }

  static final UpdateService _instance = UpdateService._();

  factory UpdateService() {
    return _instance;
  }

  bool _asked;

  versionCheck(context) async {
    if (this._asked == false) {
      this._asked = true;
      final PackageInfo info = await PackageInfo.fromPlatform();
      double currentVersion =
          double.parse(info.version.trim().replaceAll(".", ""));

      //Get Latest version info from firebase config
      final RemoteConfig remoteConfig = await RemoteConfig.instance;

      try {
        // Using default duration to force fetching from remote server.
        await remoteConfig.fetch(expiration: const Duration(seconds: 0));
        await remoteConfig.activateFetched();
        remoteConfig.getString('force_update_current_version');
        double newVersion = double.parse(remoteConfig
            .getString('force_update_current_version')
            .trim()
            .replaceAll(".", ""));
        if (newVersion > currentVersion) {
          var app_store = remoteConfig.getString('app_store_url');
          var play_store = remoteConfig.getString('play_store_url');
          
          _showVersionDialog(context, play_store, app_store);
        }
      } on FetchThrottledException catch (exception) {
        // Fetch throttled.
        print(exception);
      } catch (exception) {
        print('Unable to fetch remote config. Cached or default values will be '
            'used');
      }
    }
    //Get Current installed version of app
  }

  _showVersionDialog(context, String play_store_url, String app_store_url) async {
    this._asked = true;
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "New Update Available";
        String message =
            "There is a newer version of app available please update it now.";
        String btnLabel = "Update Now";
        String btnLabelCancel = "Later";
        return Platform.isIOS
            ? new CupertinoAlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  FlatButton(
                    child: Text(btnLabel),
                    onPressed: () => _launchURL(app_store_url),
                  ),
                  FlatButton(
                    child: Text(btnLabelCancel),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              )
            : new AlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  FlatButton(
                    child: Text(btnLabel),
                    onPressed: () => _launchURL(play_store_url),
                  ),
                  FlatButton(
                    child: Text(btnLabelCancel),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              );
      },
    );
  }

  static _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
