import 'package:itry/database/database_provider.dart';
import 'package:itry/database/models/creativity_productivity_survey.dart';
import 'package:itry/services/test_service_interface.dart';

class CreativityProductivitySurveyService
    implements TestServiceInterface<CreativityProductivitySurvey> {
  
  CreativityProductivitySurveyService();
  
  // CreativityProductivitySurveyService._();

  // static final CreativityProductivitySurveyService _instance =
  //     CreativityProductivitySurveyService._();

  // factory CreativityProductivitySurveyService() {
  //   return _instance;
  // }

  @override
  Future<CreativityProductivitySurvey> insert(
      CreativityProductivitySurvey test) async {
    var db = await DatabaseProvider().database;
    test.id = await db.insert(tableCreativityProductivitySurvey, test.toMap());
    return test;
  }

  @override
  Future<CreativityProductivitySurvey> getSingle(int id) async {
    var db = await DatabaseProvider().database;
    List<Map> maps = await db.query(tableCreativityProductivitySurvey,
        columns: [columnId, columnScore, columnDate],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return CreativityProductivitySurvey.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<List<CreativityProductivitySurvey>> getAll() async {
    var db = await DatabaseProvider().database;
    List<Map> maps = await db.query(tableCreativityProductivitySurvey);
    List<CreativityProductivitySurvey> result =
        <CreativityProductivitySurvey>[];
    maps.forEach(
        (row) => result.add(CreativityProductivitySurvey.fromMap(row)));
    return result;
  }

  @override
  Future<int> delete(int id) async {
    var db = await DatabaseProvider().database;
    return await db.delete(tableCreativityProductivitySurvey,
        where: '$columnId = ?', whereArgs: [id]);
  }

  @override
  Future<int> updateTest(CreativityProductivitySurvey test) async {
    var db = await DatabaseProvider().database;
    return await db.update(tableCreativityProductivitySurvey, test.toMap(),
        where: '$columnId = ?', whereArgs: [test.id]);
  }

  @override
  Future<List<CreativityProductivitySurvey>> getBetweenDates(
      DateTime from, DateTime to) async {
    var creativityProductivityList = await getAll();
    var creativityProductivityListFiltered = creativityProductivityList
        .where((x) =>
            DateTime.utc(x.date.year, x.date.month, x.date.day).compareTo(DateTime.utc(from.year, from.month, from.day)) >= 0 &&
            DateTime.utc(x.date.year, x.date.month, x.date.day).compareTo(DateTime.utc(to.year, to.month, to.day)) <= 0 )
        .toList();

    return creativityProductivityListFiltered;
  }

  @override
  Future<bool> isActive(DateTime date) async {
    var creativityProductivitySurveys = await getAll();
    creativityProductivitySurveys.sort((a, b) => a.date.compareTo(b.date));
    return creativityProductivitySurveys.length == 0 ||
        date
                .subtract(CreativityProductivitySurvey.testInterval)
                .compareTo(creativityProductivitySurveys.last.date) >
            0;
  }

  @override
  Future<CreativityProductivitySurvey> insertIfActive(
      CreativityProductivitySurvey test, DateTime date) async {
    var db = await DatabaseProvider().database;
    List<Map> maps = await db.query(tableCreativityProductivitySurvey);
    List<CreativityProductivitySurvey> result =
        <CreativityProductivitySurvey>[];
    maps.forEach(
        (row) => result.add(CreativityProductivitySurvey.fromMap(row)));
    result.sort((a, b) => a.date.compareTo(b.date));
    if (result.length == 0 ||
        date.subtract(CreativityProductivitySurvey.testInterval).compareTo(result.last.date) > 0) {
      test.id =
          await db.insert(tableCreativityProductivitySurvey, test.toMap());
    }
    return test;
  }
}
