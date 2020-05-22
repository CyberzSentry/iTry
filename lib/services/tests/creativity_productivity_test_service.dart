import 'package:itry/database/database_provider.dart';
import 'package:itry/database/models/creativity_productivity_test.dart';
import 'package:itry/services/tests/base_test_service.dart';
import 'package:itry/services/tests/test_service_interface.dart';

class CreativityProductivityTestService extends BaseTestService<CreativityProductivityTest>
    implements TestServiceInterface<CreativityProductivityTest> {
  
  CreativityProductivityTestService();
  
  @override
  Duration duration = CreativityProductivityTest.testInterval;

  @override
  String testTable = tableCreativityProductivityTest;

  @override
  Future<CreativityProductivityTest> getSingle(int id) async {
    var db = await DatabaseProvider().database;
    List<Map> maps = await db.query(testTable,
        columns: [columnId, columnScore, columnDate],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return CreativityProductivityTest.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<List<CreativityProductivityTest>> getAll() async {
    var db = await DatabaseProvider().database;
    List<Map> maps = await db.query(testTable);
    List<CreativityProductivityTest> result = <CreativityProductivityTest>[];
    maps.forEach((row) => result.add(CreativityProductivityTest.fromMap(row)));
    return result;
  }

  @override
  Future<CreativityProductivityTest> insertIfActive(
      CreativityProductivityTest test, DateTime date) async {
    var db = await DatabaseProvider().database;
    List<Map> maps = await db.query(testTable);
    List<CreativityProductivityTest> result = <CreativityProductivityTest>[];
    maps.forEach((row) => result.add(CreativityProductivityTest.fromMap(row)));
    result.sort((a, b) => a.date.compareTo(b.date));
    if (result.length == 0 ||
        date.subtract(CreativityProductivityTest.testInterval).compareTo(result.last.date) > 0) {
      test.id = await db.insert(testTable, test.toMap());
    }
    return test;
  }

}
