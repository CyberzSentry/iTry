
import 'package:itry/database/database_provider.dart';
import 'package:itry/database/models/first_test.dart';

 class FirstTestAccessor{

  Future<FirstTest> insert(FirstTest test) async {
    var db = await DatabaseProvider.db.database;
    test.id = await db.insert(tableTests, test.toMap());
    return test;
  }

  Future<FirstTest> getSingle(int id) async {
    var db = await DatabaseProvider.db.database;
    List<Map> maps = await db.query(tableTests,
        columns: [columnId, columnScore, columnDate],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return FirstTest.fromMap(maps.first);
    }
    return null;
  }

  Future<List<FirstTest>> getAll() async{
    var db = await DatabaseProvider.db.database;
    List<Map> maps = await db.query(tableTests);
    List<FirstTest> result = <FirstTest>[];
    maps.forEach((row) => result.add(FirstTest.fromMap(row)));
    return result;
  }

  Future<int> delete(int id) async {
    var db = await DatabaseProvider.db.database;
    return await db.delete(tableTests, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> updateTest(FirstTest test) async {
    var db = await DatabaseProvider.db.database;
    return await db.update(tableTests, test.toMap(),
        where: '$columnId = ?', whereArgs: [test.id]);
  }



}