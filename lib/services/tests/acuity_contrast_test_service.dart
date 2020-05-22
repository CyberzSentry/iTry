import 'package:itry/database/database_provider.dart';
import 'package:itry/database/models/acuity_contrast_test.dart';
import 'package:itry/services/tests/base_test_service.dart';
import 'package:itry/services/tests/test_service_interface.dart';



class AcuityContrastTestService extends BaseTestService<AcuityContrastTest>
    implements TestServiceInterface<AcuityContrastTest> {
  
  AcuityContrastTestService();

  @override
  String testTable = tableAcuityContrastTest;

  @override
  Duration duration = AcuityContrastTest.testInterval;
  
  @override
  Future<AcuityContrastTest> getSingle(int id) async {
    var db = await DatabaseProvider().database;
    List<Map> maps = await db.query(tableAcuityContrastTest,
        columns: [columnId, columnScoreLeft, columnScoreRight, columnDate],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return AcuityContrastTest.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<List<AcuityContrastTest>> getAll() async {
    var db = await DatabaseProvider().database;
    List<Map> maps = await db.query(testTable);
    List<AcuityContrastTest> result = <AcuityContrastTest>[];
    maps.forEach((row) => result.add(AcuityContrastTest.fromMap(row)));
    return result;
  }

  @override
  Future<AcuityContrastTest> insertIfActive(
      AcuityContrastTest test, DateTime date) async {
    var db = await DatabaseProvider().database;
    List<Map> maps = await db.query(testTable);
    List<AcuityContrastTest> result = <AcuityContrastTest>[];
    maps.forEach((row) => result.add(AcuityContrastTest.fromMap(row)));
    result.sort((a, b) => a.date.compareTo(b.date));
    if (result.length == 0 ||
        date.subtract(AcuityContrastTest.testInterval).compareTo(result.last.date) > 0) {
      test.id = await db.insert(testTable, test.toMap());
    }
    return test;
  }

}