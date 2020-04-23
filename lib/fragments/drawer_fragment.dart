import 'package:flutter/material.dart';
import 'package:itry/pages/home_page.dart';
import 'package:itry/pages/results/baseline_results_page.dart';
import 'package:itry/pages/results_page.dart';
import 'package:itry/pages/settings_page.dart';
import 'package:itry/pages/tests_page.dart';

class DrawerItem {
  String title;
  IconData icon;
  String path;
  DrawerItem(this.title, this.icon, this.path);
}

class DrawerFragment extends StatelessWidget {
  final drawerItems = [
    new DrawerItem(HomePage.title, HomePage.icon, HomePage.routeName),
    new DrawerItem(TestsPage.title, TestsPage.icon, TestsPage.routeName),
    new DrawerItem(ResultsPage.title, ResultsPage.icon, BaselineResultsPage.routeName),
    new DrawerItem(SettingsPage.title, SettingsPage.icon, SettingsPage.routeName)
  ];

  @override
  Widget build(BuildContext context) {
    var drawerOptions = <Widget>[];

    drawerOptions.add(
      DrawerHeader(
        decoration: BoxDecoration(
          color: Colors.green
        ),
        child: Text(
          "iTry",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );

    for (var i = 0; i < this.drawerItems.length; i++) {
      var d = this.drawerItems[i];
      drawerOptions.add(new ListTile(
        leading: Icon(d.icon),
        title: Text(d.title),
        onTap: () => Navigator.pushReplacementNamed(context, d.path),
      ));
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: drawerOptions,
      ),
    );
  }
}
