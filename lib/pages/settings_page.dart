import 'package:flutter/material.dart';
import 'package:itry/fragments/drawer_fragment.dart';

class SettingsPage extends StatefulWidget {
  static const String routeName = '/settings';
  static const String title = "Settings";
  static const IconData icon = Icons.settings;

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(SettingsPage.title),
      ),
      drawer: DrawerFragment(),
      body: Center(
        child: Text("settings"),
      ),
    );
  }
}