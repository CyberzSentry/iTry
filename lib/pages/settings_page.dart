import 'package:flutter/material.dart';
import 'package:itry/database/database_provider.dart';
import 'package:itry/fragments/drawer_fragment.dart';
import 'package:itry/services/ads_service.dart';
import 'package:itry/services/settings_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  static const String routeName = '/settings';
  static const String title = "Settings";
  static const IconData icon = Icons.settings;

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Settings _settings;
  SettingsService service = SettingsService();
  DatabaseProvider database = DatabaseProvider();

  void _resetApplication() {
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
                onPressed: _resetApplicationConfirmed,
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

  void _resetApplicationConfirmed() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    database.resetDatabase();
    setState(() {
      
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(SettingsPage.title),
      ),
      drawer: DrawerFragment(),
      body: FutureBuilder<Settings>(
        future: service.settings,
        builder: (BuildContext context, AsyncSnapshot<Settings> snapshot) {
          if (snapshot.hasData) {
            _settings = snapshot.data;
            return ListView(
              children: <Widget>[
                SwitchListTile(
                  title: Text('Notifications'),
                  value: _settings.notifications,
                  onChanged: (value) => setState(() {
                    service.notifications = value;
                  }),
                ),
                ListTile(
                  title: Text('Reset application'),
                  onTap: _resetApplication,
                  trailing: Icon(Icons.delete_outline),
                )
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  @override
  void initState() {
    AdsService().showBanner();
    super.initState();
  }
}
