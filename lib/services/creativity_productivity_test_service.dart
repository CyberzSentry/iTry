import 'package:itry/database/database_provider.dart';
import 'package:itry/database/models/creativity_productivity_test.dart';

class CreativityProductivityTestService{

  CreativityProductivityTestService._();

  static final CreativityProductivityTestService _instance = CreativityProductivityTestService._();

  factory CreativityProductivityTestService() {
    return _instance;
  }

  Future<CreativityProductivityTest> insert(CreativityProductivityTest test) async {
    var db = await DatabaseProvider().database;
    test.id = await db.insert(tableCreativityProductivityTest, test.toMap());
    return test;
  }

  Future<CreativityProductivityTest> getSingle(int id) async {
    var db = await DatabaseProvider().database;
    List<Map> maps = await db.query(tableCreativityProductivityTest,
        columns: [columnId, columnScore, columnDate],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return CreativityProductivityTest.fromMap(maps.first);
    }
    return null;
  }

  Future<List<CreativityProductivityTest>> getAll() async{
    var db = await DatabaseProvider().database;
    List<Map> maps = await db.query(tableCreativityProductivityTest);
    List<CreativityProductivityTest> result = <CreativityProductivityTest>[];
    maps.forEach((row) => result.add(CreativityProductivityTest.fromMap(row)));
    return result;
  }

  Future<int> delete(int id) async {
    var db = await DatabaseProvider().database;
    return await db.delete(tableCreativityProductivityTest, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> updateTest(CreativityProductivityTest test) async {
    var db = await DatabaseProvider().database;
    return await db.update(tableCreativityProductivityTest, test.toMap(),
        where: '$columnId = ?', whereArgs: [test.id]);
  }

  Future<List<CreativityProductivityTest>> getBetweenDates(DateTime from, DateTime to) async {
    var creativityProductivityList = await getAll();
    var creativityProductivityListFiltered = creativityProductivityList.where((x) =>
        x.date.isAfter(from.add(Duration(days: -1))) &
        x.date.isBefore(to.add(Duration(days: 1)))).toList();

    return creativityProductivityListFiltered;
  }

  Future<bool> isActive(DateTime date) async {
    var creativityProductivitySurveys = await getAll();
    creativityProductivitySurveys.sort((a, b) => a.date.compareTo(b.date));
    return creativityProductivitySurveys.length == 0 ||
        date
                .subtract(testInterval)
                .compareTo(creativityProductivitySurveys.last.date) >
            0;
  }
}