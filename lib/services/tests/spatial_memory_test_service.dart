import 'package:itry/database/database_provider.dart';
import 'package:itry/database/models/spatial_memory_test.dart';
import 'package:itry/services/tests/test_service_interface.dart';

class SpatialMemoryTestService
    implements TestServiceInterface<SpatialMemoryTest> {
  
  SpatialMemoryTestService();

  // SpatialMemoryTestService._();

  // static final SpatialMemoryTestService _instance =
  //     SpatialMemoryTestService._();

  // factory SpatialMemoryTestService() {
  //   return _instance;
  // }

  @override
  Future<SpatialMemoryTest> insert(SpatialMemoryTest test) async {
    var db = await DatabaseProvider().database;
    test.id = await db.insert(tableSpatialMemoryTests, test.toMap());
    return test;
  }

  @override
  Future<SpatialMemoryTest> getSingle(int id) async {
    var db = await DatabaseProvider().database;
    List<Map> maps = await db.query(tableSpatialMemoryTests,
        columns: [columnId, columnScore, columnDate],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return SpatialMemoryTest.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<List<SpatialMemoryTest>> getAll() async {
    var db = await DatabaseProvider().database;
    List<Map> maps = await db.query(tableSpatialMemoryTests);
    List<SpatialMemoryTest> result = <SpatialMemoryTest>[];
    maps.forEach((row) => result.add(SpatialMemoryTest.fromMap(row)));
    return result;
  }

  @override
  Future<int> delete(int id) async {
    var db = await DatabaseProvider().database;
    return await db.delete(tableSpatialMemoryTests,
        where: '$columnId = ?', whereArgs: [id]);
  }

  @override
  Future<int> updateTest(SpatialMemoryTest test) async {
    var db = await DatabaseProvider().database;
    return await db.update(tableSpatialMemoryTests, test.toMap(),
        where: '$columnId = ?', whereArgs: [test.id]);
  }

  @override
  Future<List<SpatialMemoryTest>> getBetweenDates(
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
        date.subtract(SpatialMemoryTest.testInterval).compareTo(tests.last.date) > 0;
  }

  @override
  Future<SpatialMemoryTest> insertIfActive(
      SpatialMemoryTest test, DateTime date) async {
    var db = await DatabaseProvider().database;
    List<Map> maps = await db.query(tableSpatialMemoryTests);
    List<SpatialMemoryTest> result = <SpatialMemoryTest>[];
    maps.forEach((row) => result.add(SpatialMemoryTest.fromMap(row)));
    result.sort((a, b) => a.date.compareTo(b.date));
    if (result.length == 0 ||
        date.subtract(SpatialMemoryTest.testInterval).compareTo(result.last.date) > 0) {
      test.id = await db.insert(tableSpatialMemoryTests, test.toMap());
    }
    return test;
  }
}
