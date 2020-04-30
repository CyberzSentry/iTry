import 'package:flutter/cupertino.dart';

abstract class TestServiceInterface<T> {
  @required
  Future<T> insert(T test) {
    return null;
  }

  @required
  Future<T> insertIfActive(T test, DateTime date) {
    return null;
  }

  @required
  Future<T> getSingle(int id) {
    return null;
  }

  @required
  Future<List<T>> getAll() {
    return null;
  }

  @required
  Future<int> delete(int id) {
    return null;
  }

  @required
  Future<int> updateTest(T test) {
    return null;
  }

  @required
  Future<List<T>> getBetweenDates(DateTime from, DateTime to) {
    return null;
  }

  @required
  Future<bool> isActive(DateTime date) {
    return null;
  }
}
