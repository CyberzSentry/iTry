import 'package:itry/database/database_provider.dart';
import 'package:itry/database/models/spatial_memory_test.dart';

class SpatialMemoryTestService {

  SpatialMemoryTestService._();

  static final SpatialMemoryTestService _instance = SpatialMemoryTestService._();

  factory SpatialMemoryTestService() {
    return _instance;
  }

  Future<SpatialMemoryTest> insert(SpatialMemoryTest test) async {
    var db = await DatabaseProvider().database;
    test.id = await db.insert(tableSpatialMemoryTests, test.toMap());
    return test;
  }

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

  Future<List<SpatialMemoryTest>> getAll() async {
    var db = await DatabaseProvider().database;
    List<Map> maps = await db.query(tableSpatialMemoryTests);
    List<SpatialMemoryTest> result = <SpatialMemoryTest>[];
    maps.forEach((row) => result.add(SpatialMemoryTest.fromMap(row)));
    return result;
  }

  Future<int> delete(int id) async {
    var db = await DatabaseProvider().database;
    return await db.delete(tableSpatialMemoryTests,
        where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> updateTest(SpatialMemoryTest test) async {
    var db = await DatabaseProvider().database;
    return await db.update(tableSpatialMemoryTests, test.toMap(),
        where: '$columnId = ?', whereArgs: [test.id]);
  }

  Future<List<SpatialMemoryTest>> getBetweenDates(DateTime from, DateTime to) async {
    var testList = await getAll();
    var testListFiltered = testList.where((x) =>
        x.date.isAfter(from.add(Duration(days: -1))) &
        x.date.isBefore(to.add(Duration(days: 1)))).toList();

    return testListFiltered;
  }

  Future<bool> isActive(DateTime date) async {
    var tests = await getAll();
    tests.sort((a, b) => a.date.compareTo(b.date));
    return tests.length == 0 ||
        date
                .subtract(testInterval)
                .compareTo(tests.last.date) >
            0;
  }
}
