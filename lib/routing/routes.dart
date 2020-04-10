import 'package:flutter/material.dart';
import 'package:itry/pages/home_page.dart';
import 'package:itry/pages/results/baseline_results_page.dart';
import 'package:itry/pages/results_page.dart';
import 'package:itry/pages/settings_page.dart';
import 'package:itry/pages/tests/first_test_page.dart';
import 'package:itry/pages/tests_page.dart';

 var routes = <String, WidgetBuilder>{
  HomePage.routeName : (context) => HomePage(),
  ResultsPage.routeName : (context) => ResultsPage(),
  SettingsPage.routeName : (context) => SettingsPage(),
  TestsPage.routeName : (context) => TestsPage(),
  FirstTestPage.routeName : (context) => FirstTestPage(),
  BaselineResultsPage.routeName : (context) => BaselineResultsPage(),
};