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
  void _resetApplicaton() {
    print('Reset application');

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Reset'),
            content: Text(
                'Are you sure you want to reset the app? This will result in losing all information you gathered through tests.'),
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                onPressed: () {},
                child: Text('Continue'),
              ),
              FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Abort'),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(SettingsPage.title),
      ),
      drawer: DrawerFragment(),
      body: ListView(
        children: <Widget>[
          SwitchListTile(
              title: Text('Notifications'), value: true, onChanged: null),
          ListTile(
            title: Text('Reset application'),
            onTap: _resetApplicaton,
            trailing: Icon(Icons.delete_outline),
          )
        ],
      ),
    );
  }
}
