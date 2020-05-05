import 'package:itry/database/database_provider.dart';
import 'package:itry/database/models/pavsat_test.dart';
import 'package:itry/services/test_service_interface.dart';

class PavsatTestService
    implements TestServiceInterface<PavsatTest> {
  
  PavsatTestService();

  // SpatialMemoryTestService._();

  // static final SpatialMemoryTestService _instance =
  //     SpatialMemoryTestService._();

  // factory SpatialMemoryTestService() {
  //   return _instance;
  // }

  @override
  Future<PavsatTest> insert(PavsatTest test) async {
    var db = await DatabaseProvider().database;
    test.id = await db.insert(tablePavsatTests, test.toMap());
    return test;
  }

  @override
  Future<PavsatTest> getSingle(int id) async {
    var db = await DatabaseProvider().database;
    List<Map> maps = await db.query(tablePavsatTests,
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
    List<Map> maps = await db.query(tablePavsatTests);
    List<PavsatTest> result = <PavsatTest>[];
    maps.forEach((row) => result.add(PavsatTest.fromMap(row)));
    return result;
  }

  @override
  Future<int> delete(int id) async {
    var db = await DatabaseProvider().database;
    return await db.delete(tablePavsatTests,
        where: '$columnId = ?', whereArgs: [id]);
  }

  @override
  Future<int> updateTest(PavsatTest test) async {
    var db = await DatabaseProvider().database;
    return await db.update(tablePavsatTests, test.toMap(),
        where: '$columnId = ?', whereArgs: [test.id]);
  }

  @override
  Future<List<PavsatTest>> getBetweenDates(
      DateTime from, DateTime to) async {
    var testList = await getAll();
    var testListFiltered = testList
        .where((x) =>
            DateTime.utc(x.date.year, x.date.month, x.date.day).compareTo(DateTime.utc(from.year, from.month, from.day)) >= 0 &&
            DateTime.utc(x.date.year, x.date.month, x.date.day).compareTo(DateTime.utc(to.year, to.month, to.day)) <= 0 )
        .toList();

    return testListFiltered;
  }

  @override
  Future<bool> isActive(DateTime date) async {
    var tests = await getAll();
    tests.sort((a, b) => a.date.compareTo(b.date));
    return tests.length == 0 ||
        date.subtract(PavsatTest.testInterval).compareTo(tests.last.date) > 0;
  }

  @override
  Future<PavsatTest> insertIfActive(
      PavsatTest test, DateTime date) async {
    var db = await DatabaseProvider().database;
    List<Map> maps = await db.query(tablePavsatTests);
    List<PavsatTest> result = <PavsatTest>[];
    maps.forEach((row) => result.add(PavsatTest.fromMap(row)));
    result.sort((a, b) => a.date.compareTo(b.date));
    if (result.length == 0 ||
        date.subtract(PavsatTest.testInterval).compareTo(result.last.date) > 0) {
      test.id = await db.insert(tablePavsatTests, test.toMap());
    }
    return test;
  }
}
