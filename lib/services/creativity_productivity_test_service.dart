import 'package:itry/database/database_provider.dart';
import 'package:itry/database/models/creativity_productivity_test.dart';
import 'package:itry/services/test_service_interface.dart';

class CreativityProductivityTestService implements TestServiceInterface<CreativityProductivityTest>{

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
    var surveysList = await getAll();
    var surveysListFiltered = surveysList.where((x) =>
        x.date.isAfter(from.add(Duration(days: -1))) &
        x.date.isBefore(to.add(Duration(days: 1)))).toList();

    return surveysListFiltered;
  }

  Future<bool> isActive(DateTime date) async {
    var surveys = await getAll();
    surveys.sort((a, b) => a.date.compareTo(b.date));
    return surveys.length == 0 ||
        date
                .subtract(testInterval)
                .compareTo(surveys.last.date) >
            0;
  }
}