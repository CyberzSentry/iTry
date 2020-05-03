import 'package:itry/database/database_provider.dart';
import 'package:itry/database/models/finger_tapping_test.dart';
import 'package:itry/services/test_service_interface.dart';

class FingerTappingTestService
    implements TestServiceInterface<FingerTappingTest> {
  
  FingerTappingTestService();

  // FingerTappingTestService._();

  // static final FingerTappingTestService _instance =
  //     FingerTappingTestService._();

  // factory FingerTappingTestService() {
  //   return _instance;
  // }

  @override
  Future<FingerTappingTest> insert(FingerTappingTest test) async {
    var db = await DatabaseProvider().database;
    test.id = await db.insert(tableFingerTappingTests, test.toMap());
    return test;
  }

  @override
  Future<FingerTappingTest> getSingle(int id) async {
    var db = await DatabaseProvider().database;
    List<Map> maps = await db.query(tableFingerTappingTests,
        columns: [
          columnId,
          columnScoreNonDominant,
          columnScoreDominant,
          columnDate
        ],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return FingerTappingTest.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<List<FingerTappingTest>> getAll() async {
    var db = await DatabaseProvider().database;
    List<Map> maps = await db.query(tableFingerTappingTests);
    List<FingerTappingTest> result = <FingerTappingTest>[];
    maps.forEach((row) => result.add(FingerTappingTest.fromMap(row)));
    return result;
  }

  @override
  Future<int> delete(int id) async {
    var db = await DatabaseProvider().database;
    return await db.delete(tableFingerTappingTests,
        where: '$columnId = ?', whereArgs: [id]);
  }

  @override
  Future<int> updateTest(FingerTappingTest test) async {
    var db = await DatabaseProvider().database;
    return await db.update(tableFingerTappingTests, test.toMap(),
        where: '$columnId = ?', whereArgs: [test.id]);
  }

  @override
  Future<List<FingerTappingTest>> getBetweenDates(
      DateTime from, DateTime to) async {
    var testList = await getAll();
    var testListFiltered = testList
        .where((x) =>
            x.date.isAfter(from.add(Duration(days: -1))) &
            x.date.isBefore(to.add(Duration(days: 1))))
        .toList();

    return testListFiltered;
  }

  @override
  Future<bool> isActive(DateTime date) async {
    var tests = await getAll();
    tests.sort((a, b) => a.date.compareTo(b.date));
    return tests.length == 0 ||
        date.subtract(FingerTappingTest.testInterval).compareTo(tests.last.date) > 0;
  }

  @override
  Future<FingerTappingTest> insertIfActive(
      FingerTappingTest test, DateTime date) async {
    var db = await DatabaseProvider().database;
    List<Map> maps = await db.query(tableFingerTappingTests);
    List<FingerTappingTest> result = <FingerTappingTest>[];
    maps.forEach((row) => result.add(FingerTappingTest.fromMap(row)));
    result.sort((a, b) => a.date.compareTo(b.date));
    if (result.length == 0 ||
        date.subtract(FingerTappingTest.testInterval).compareTo(result.last.date) > 0) {
      test.id = await db.insert(tableFingerTappingTests, test.toMap());
    }
    return test;
  }
}
