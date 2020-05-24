import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:itry/services/settings_service.dart';

class NotificationsService {
  NotificationsService._() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    var initializationSettingsAndroid =
        AndroidInitializationSettings("@mipmap/icon_grayscale");
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onSelectNotification: selectNotification).then((value) {_initialized = value;});
  }

  bool _initialized = false;

  static final NotificationsService _instance = NotificationsService._();

  factory NotificationsService() {
    return _instance;
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  Future selectNotification(String payload) async {
    if (payload != null) {
      print('notification payload: ' + payload);
      switch (payload) {
        case "tests":
          //Navigator.pushReplacementNamed(,TestsPage.routeName);
          break;
        default:
          break;
      }
    }
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    // showDialog(
    //   context: null,
    //   builder: (BuildContext context) => CupertinoAlertDialog(
    //     title: Text(title),
    //     content: Text(body),
    //     actions: [
    //       CupertinoDialogAction(
    //         isDefaultAction: true,
    //         child: Text('Ok'),
    //         onPressed: () async {
    //           Navigator.of(context, rootNavigator: true).pop();
    //           await Navigator.push(
    //             context,
    //             MaterialPageRoute(
    //               builder: (context) => NotificationPage(),
    //             ),
    //           );
    //         },
    //       )
    //     ],
    //   ),
    // );
  }

  void scheduleTestNotification(Duration duration) async {
    var scheduledNotificationDateTime = DateTime.now().add(duration);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'itry_channel_id',
        'itry_channel_name',
        'itry_channel_description',
        groupKey: 'itry_test_notification',
        importance: Importance.High,
        visibility: NotificationVisibility.Public);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();

    NotificationDetails platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    if (await SettingsService().getNotifications()) {
      if (_initialized) {
        await flutterLocalNotificationsPlugin.schedule(
            0,
            'A test is ready again',
            'You can check it in the \'tests\' tab.',
            scheduledNotificationDateTime,
            platformChannelSpecifics,
            androidAllowWhileIdle: true,
            payload: "tests");
      }
    }
  }
}
