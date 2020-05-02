import 'package:flutter/material.dart';
import 'package:itry/pages/home_page.dart';
import 'package:itry/pages/results/baseline_results_page.dart';
import 'package:itry/pages/results_page.dart';
import 'package:itry/pages/settings_page.dart';
import 'package:itry/pages/tests/anixety_survey_page.dart';
import 'package:itry/pages/tests/creativity_productivity_survey_page.dart';
import 'package:itry/pages/tests/creativity_productivity_test_page.dart';
import 'package:itry/pages/tests/depression_survey_page.dart';
import 'package:itry/pages/tests/finger_tapping_test_page.dart';
import 'package:itry/pages/tests/spatial_memory_test_page.dart';
import 'package:itry/pages/tests/stress_survey_page.dart';
import 'package:itry/pages/tests_page.dart';

  var routes = <String, WidgetBuilder>{
  HomePage.routeName : (context) => HomePage(),
  ResultsPage.routeName : (context) => ResultsPage(),
  SettingsPage.routeName : (context) => SettingsPage(),
  TestsPage.routeName : (context) => TestsPage(),
  BaselineResultsPage.routeName : (context) => BaselineResultsPage(),
  FingerTappingTestPage.routeName : (context) => FingerTappingTestPage(),
  CreativityProductivitySurveyPage.routeName : (context) => CreativityProductivitySurveyPage(),
  CreativityProductivityTestPage.routeName : (context) => CreativityProductivityTestPage(),
  SpatialMemoryTestPage.routeName : (context) => SpatialMemoryTestPage(),
  DepressionSurveyPage.routeName : (context) => DepressionSurveyPage(),
  StressSurveyPage.routeName : (context) => StressSurveyPage(),
  AnxietySurveyPage.routeName : (context) => AnxietySurveyPage(),
  // ReportPage.routeName : (context) => ReportPage(),
};