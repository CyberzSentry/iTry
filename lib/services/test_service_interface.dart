import 'package:flutter/cupertino.dart';
import 'package:itry/database/models/test_interface.dart';

abstract class TestServiceInterface<Test extends TestInterface> {
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
