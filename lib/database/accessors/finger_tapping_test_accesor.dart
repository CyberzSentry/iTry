import 'package:itry/database/database_provider.dart';
import 'package:itry/database/models/finger_tapping_test.dart';

 class FingerTappingTestAccessor{

  Future<FingerTappingTest> insert(FingerTappingTest test) async {
    var db = await DatabaseProvider.db.database;
    test.id = await db.insert(tableFingerTappingTests, test.toMap());
    return test;
  }

  Future<FingerTappingTest> getSingle(int id) async {
    var db = await DatabaseProvider.db.database;
    List<Map> maps = await db.query(tableFingerTappingTests,
        columns: [columnId, columnScore, columnDate],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return FingerTappingTest.fromMap(maps.first);
    }
    return null;
  }

  Future<List<FingerTappingTest>> getAll() async{
    var db = await DatabaseProvider.db.database;
    List<Map> maps = await db.query(tableFingerTappingTests);
    List<FingerTappingTest> result = <FingerTappingTest>[];
    maps.forEach((row) => result.add(FingerTappingTest.fromMap(row)));
    return result;
  }

  Future<int> delete(int id) async {
    var db = await DatabaseProvider.db.database;
    return await db.delete(tableFingerTappingTests, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> updateTest(FingerTappingTest test) async {
    var db = await DatabaseProvider.db.database;
    return await db.update(tableFingerTappingTests, test.toMap(),
        where: '$columnId = ?', whereArgs: [test.id]);
  }
}