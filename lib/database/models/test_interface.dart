import 'package:flutter/cupertino.dart';

abstract class TestInterface{

  @required
  DateTime date;

  @required
  Duration getTestInterval();
}