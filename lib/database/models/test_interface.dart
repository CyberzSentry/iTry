import 'package:flutter/cupertino.dart';

abstract class TestInterface{

  @required
  int id;

  @required
  DateTime date;

  @required
  double get percentageScore;

  @required
  Duration getTestInterval();
}