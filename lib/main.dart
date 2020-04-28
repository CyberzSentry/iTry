import 'package:flutter/material.dart';
import 'package:itry/routing/routes.dart';
import 'package:itry/services/ads_service.dart';
import 'package:itry/services/notifications_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    NotificationsService();
    AdsService();
    
    return MaterialApp(
      title: 'iTry',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/',
      routes: routes,
    );
  }
}