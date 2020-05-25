import 'package:flutter/cupertino.dart';
import 'package:itry/database/models/tests/test_interface.dart';

abstract class TestServiceInterface<Test extends TestInterface> {

  @required
  String testTable;

  @required
  String id;

  @required
  Duration duration;  

  @required
  Future<Test> insert(Test test) {
    return null;
  }

  @required
  Future<Test> insertIfActive(Test test, DateTime date) {
    return null;
  }

  @required
  Future<Test> getSingle(int id) {
    return null;
  }

  @required
  Future<List<Test>> getAll() {
    return null;
  }

  @required
  Future<int> delete(int id) {
    return null;
  }

  @required
  Future<int> updateTest(Test test) {
    return null;
  }

  @required
  Future<List<Test>> getBetweenDates(DateTime from, DateTime to) {
    return null;
  }

  @required
  Future<bool> isActive(DateTime date) {
    return null;
  }
}
