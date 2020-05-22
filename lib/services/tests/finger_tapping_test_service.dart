import 'package:itry/database/database_provider.dart';
import 'package:itry/database/models/finger_tapping_test.dart';
import 'package:itry/services/tests/base_test_service.dart';
import 'package:itry/services/tests/test_service_interface.dart';

class FingerTappingTestService extends BaseTestService<FingerTappingTest>
    implements TestServiceInterface<FingerTappingTest> {
  
  FingerTappingTestService();
  
  @override
  Duration duration = FingerTappingTest.testInterval;

  @override
  String testTable = tableFingerTappingTests;

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
