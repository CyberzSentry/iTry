import 'package:itry/database/database_provider.dart';
import 'package:itry/database/models/creativity_productivity_test.dart';
import 'package:itry/services/tests/test_service_interface.dart';

class CreativityProductivityTestService
    implements TestServiceInterface<CreativityProductivityTest> {
  
  CreativityProductivityTestService();
  
  // CreativityProductivityTestService._();

  // static final CreativityProductivityTestService _instance =
  //     CreativityProductivityTestService._();

  // factory CreativityProductivityTestService() {
  //   return _instance;
  // }

  @override
  Future<CreativityProductivityTest> insert(
      CreativityProductivityTest test) async {
    var db = await DatabaseProvider().database;
    test.id = await db.insert(tableCreativityProductivityTest, test.toMap());
    return test;
  }

  @override
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

  @override
  Future<List<CreativityProductivityTest>> getAll() async {
    var db = await DatabaseProvider().database;
    List<Map> maps = await db.query(tableCreativityProductivityTest);
    List<CreativityProductivityTest> result = <CreativityProductivityTest>[];
    maps.forEach((row) => result.add(CreativityProductivityTest.fromMap(row)));
    return result;
  }

  @override
  Future<int> delete(int id) async {
    var db = await DatabaseProvider().database;
    return await db.delete(tableCreativityProductivityTest,
        where: '$columnId = ?', whereArgs: [id]);
  }

  @override
  Future<int> updateTest(CreativityProductivityTest test) async {
    var db = await DatabaseProvider().database;
    return await db.update(tableCreativityProductivityTest, test.toMap(),
        where: '$columnId = ?', whereArgs: [test.id]);
  }

  @override
  Future<List<CreativityProductivityTest>> getBetweenDates(
      DateTime from, DateTime to) async {
    var surveysList = await getAll();
    var surveysListFiltered = surveysList
        .where((x) =>
            DateTime.utc(x.date.year, x.date.month, x.date.day).compareTo(DateTime.utc(from.year, from.month, from.day)) >= 0 &&
            DateTime.utc(x.date.year, x.date.month, x.date.day).compareTo(DateTime.utc(to.year, to.month, to.day)) <= 0 )
        .toList();

    return surveysListFiltered;
  }

  @override
  Future<bool> isActive(DateTime date) async {
    var surveys = await getAll();
    surveys.sort((a, b) => a.date.compareTo(b.date));
    return surveys.length == 0 ||
        date.subtract(CreativityProductivityTest.testInterval).compareTo(surveys.last.date) > 0;
  }

  @override
  Future<CreativityProductivityTest> insertIfActive(
      CreativityProductivityTest test, DateTime date) async {
    var db = await DatabaseProvider().database;
    List<Map> maps = await db.query(tableCreativityProductivityTest);
    List<CreativityProductivityTest> result = <CreativityProductivityTest>[];
    maps.forEach((row) => result.add(CreativityProductivityTest.fromMap(row)));
    result.sort((a, b) => a.date.compareTo(b.date));
    if (result.length == 0 ||
        date.subtract(CreativityProductivityTest.testInterval).compareTo(result.last.date) > 0) {
      test.id = await db.insert(tableCreativityProductivityTest, test.toMap());
    }
    return test;
  }
}
