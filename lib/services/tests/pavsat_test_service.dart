import 'package:itry/database/database_provider.dart';
import 'package:itry/database/models/tests/pavsat_test.dart';
import 'package:itry/services/tests/base_test_service.dart';
import 'package:itry/services/tests/test_service_interface.dart';

class PavsatTestService extends BaseTestService<PavsatTest>
    implements TestServiceInterface<PavsatTest> {
  
  PavsatTestService();

  @override
  Duration duration = PavsatTest.testInterval;

  @override
  String testTable = tablePavsatTests;

  @override
  Future<PavsatTest> getSingle(int id) async {
    var db = await DatabaseProvider().database;
    List<Map> maps = await db.query(testTable,
        columns: [columnId, columnScore, columnDate],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return PavsatTest.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<List<PavsatTest>> getAll() async {
    var db = await DatabaseProvider().database;
    List<Map> maps = await db.query(testTable);
    List<PavsatTest> result = <PavsatTest>[];
    maps.forEach((row) => result.add(PavsatTest.fromMap(row)));
    return result;
  }

  @override
  Future<PavsatTest> insertIfActive(
      PavsatTest test, DateTime date) async {
    var db = await DatabaseProvider().database;
    List<Map> maps = await db.query(testTable);
    List<PavsatTest> result = <PavsatTest>[];
    maps.forEach((row) => result.add(PavsatTest.fromMap(row)));
    result.sort((a, b) => a.date.compareTo(b.date));
    if (result.length == 0 ||
        date.subtract(PavsatTest.testInterval).compareTo(result.last.date) > 0) {
      test.id = await db.insert(testTable, test.toMap());
    }
    return test;
  }
}
