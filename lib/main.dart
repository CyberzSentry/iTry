import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:itry/ads/ads.dart';
import 'package:itry/routing/routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    FirebaseAdMob.instance.initialize(appId: Ads.getAppId());

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