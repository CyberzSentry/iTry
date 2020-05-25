import 'package:itry/database/database_provider.dart';
import 'package:itry/database/models/tests/spatial_memory_test.dart';
import 'package:itry/services/tests/base_test_service.dart';
import 'package:itry/services/tests/test_service_interface.dart';

class SpatialMemoryTestService extends BaseTestService<SpatialMemoryTest>
    implements TestServiceInterface<SpatialMemoryTest> {
  
  SpatialMemoryTestService();

  
  @override
  Duration duration = SpatialMemoryTest.testInterval;

  @override
  String testTable = tableSpatialMemoryTests;

  @override
  Future<SpatialMemoryTest> getSingle(int id) async {
    var db = await DatabaseProvider().database;
    List<Map> maps = await db.query(testTable,
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
    List<Map> maps = await db.query(testTable);
    List<SpatialMemoryTest> result = <SpatialMemoryTest>[];
    maps.forEach((row) => result.add(SpatialMemoryTest.fromMap(row)));
    return result;
  }

  @override
  Future<SpatialMemoryTest> insertIfActive(
      SpatialMemoryTest test, DateTime date) async {
    var db = await DatabaseProvider().database;
    List<Map> maps = await db.query(testTable);
    List<SpatialMemoryTest> result = <SpatialMemoryTest>[];
    maps.forEach((row) => result.add(SpatialMemoryTest.fromMap(row)));
    result.sort((a, b) => a.date.compareTo(b.date));
    if (result.length == 0 ||
        date.subtract(SpatialMemoryTest.testInterval).compareTo(result.last.date) > 0) {
      test.id = await db.insert(testTable, test.toMap());
    }
    return test;
  }
}
