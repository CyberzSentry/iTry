import 'package:itry/database/database_provider.dart';
import 'package:itry/database/models/stress_survey.dart';
import 'package:itry/services/tests/test_service_interface.dart';

class StressSurveyService
    implements TestServiceInterface<StressSurvey> {
  
  StressSurveyService();
  // StressSurveyService._();

  // static final StressSurveyService _instance =
  //     StressSurveyService._();

  // factory StressSurveyService() {
  //   return _instance;
  // }

  @override
  Future<StressSurvey> insert(
      StressSurvey test) async {
    var db = await DatabaseProvider().database;
    test.id = await db.insert(tableStressSurvey, test.toMap());
    return test;
  }

  @override
  Future<StressSurvey> getSingle(int id) async {
    var db = await DatabaseProvider().database;
    List<Map> maps = await db.query(tableStressSurvey,
        columns: [columnId, columnScore, columnDate],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return StressSurvey.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<List<StressSurvey>> getAll() async {
    var db = await DatabaseProvider().database;
    List<Map> maps = await db.query(tableStressSurvey);
    List<StressSurvey> result =
        <StressSurvey>[];
    maps.forEach(
        (row) => result.add(StressSurvey.fromMap(row)));
    return result;
  }

  @override
  Future<int> delete(int id) async {
    var db = await DatabaseProvider().database;
    return await db.delete(tableStressSurvey,
        where: '$columnId = ?', whereArgs: [id]);
  }

  @override
  Future<int> updateTest(StressSurvey test) async {
    var db = await DatabaseProvider().database;
    return await db.update(tableStressSurvey, test.toMap(),
        where: '$columnId = ?', whereArgs: [test.id]);
  }

  @override
  Future<List<StressSurvey>> getBetweenDates(
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
                .subtract(StressSurvey.testInterval)
                .compareTo(creativityProductivitySurveys.last.date) >
            0;
  }

  @override
  Future<StressSurvey> insertIfActive(
      StressSurvey test, DateTime date) async {
    var db = await DatabaseProvider().database;
    List<Map> maps = await db.query(tableStressSurvey);
    List<StressSurvey> result =
        <StressSurvey>[];
    maps.forEach(
        (row) => result.add(StressSurvey.fromMap(row)));
    result.sort((a, b) => a.date.compareTo(b.date));
    if (result.length == 0 ||
        date.subtract(StressSurvey.testInterval).compareTo(result.last.date) > 0) {
      test.id =
          await db.insert(tableStressSurvey, test.toMap());
    }
    return test;
  }
}
