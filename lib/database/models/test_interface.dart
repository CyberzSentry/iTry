import 'package:flutter/cupertino.dart';

abstract class TestInterface{

  @required
  int id;

  @required
  DateTime date;

  @required
  double get percentageScore;

  @required
  Map<String, dynamic> toMap();

  @required
  Duration getTestInterval();

  @required
  double compareResults(TestInterface test);
}