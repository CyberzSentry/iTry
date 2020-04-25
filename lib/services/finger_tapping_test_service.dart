import 'package:itry/database/database_provider.dart';
import 'package:itry/database/models/finger_tapping_test.dart';

class FingerTappingTestService {

  FingerTappingTestService._();

  static final FingerTappingTestService _instance = FingerTappingTestService._();

  factory FingerTappingTestService() {
    return _instance;
  }

  Future<FingerTappingTest> insert(FingerTappingTest test) async {
    var db = await DatabaseProvider().database;
    test.id = await db.insert(tableFingerTappingTests, test.toMap());
    return test;
  }

  Future<FingerTappingTest> getSingle(int id) async {
    var db = await DatabaseProvider().database;
    List<Map> maps = await db.query(tableFingerTappingTests,
        columns: [columnId, columnScoreNonDominant, columnScoreDominant, columnDate],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return FingerTappingTest.fromMap(maps.first);
    }
    return null;
  }

  Future<List<FingerTappingTest>> getAll() async {
    var db = await DatabaseProvider().database;
    List<Map> maps = await db.query(tableFingerTappingTests);
    List<FingerTappingTest> result = <FingerTappingTest>[];
    maps.forEach((row) => result.add(FingerTappingTest.fromMap(row)));
    return result;
  }

  Future<int> delete(int id) async {
    var db = await DatabaseProvider().database;
    return await db.delete(tableFingerTappingTests,
        where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> updateTest(FingerTappingTest test) async {
    var db = await DatabaseProvider().database;
    return await db.update(tableFingerTappingTests, test.toMap(),
        where: '$columnId = ?', whereArgs: [test.id]);
  }

  Future<List<FingerTappingTest>> getBetweenDates(DateTime from, DateTime to) async {
    var fingerTappingTestList = await getAll();
    var fingerTappingTestListFiltered = fingerTappingTestList.where((x) =>
        x.date.isAfter(from.add(Duration(days: -1))) &
        x.date.isBefore(to.add(Duration(days: 1)))).toList();

    return fingerTappingTestListFiltered;
  }

  Future<bool> isActive(DateTime date) async {
    var fingTappTests = await getAll();
    fingTappTests.sort((a, b) => a.date.compareTo(b.date));
    return fingTappTests.length == 0 ||
        date
                .subtract(testInterval)
                .compareTo(fingTappTests.last.date) >
            0;
  }
}
