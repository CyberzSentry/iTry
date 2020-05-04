import 'package:itry/database/database_provider.dart';
import 'package:itry/database/models/depression_survey.dart';
import 'package:itry/services/test_service_interface.dart';

class DepressionSurveyService
    implements TestServiceInterface<DepressionSurvey> {
  
  DepressionSurveyService();

  // DepressionSurveyService._();

  // static final DepressionSurveyService _instance =
  //     DepressionSurveyService._();

  // factory DepressionSurveyService() {
  //   return _instance;
  // }

  @override
  Future<DepressionSurvey> insert(
      DepressionSurvey test) async {
    var db = await DatabaseProvider().database;
    test.id = await db.insert(tableDepressionSurvey, test.toMap());
    return test;
  }

  @override
  Future<DepressionSurvey> getSingle(int id) async {
    var db = await DatabaseProvider().database;
    List<Map> maps = await db.query(tableDepressionSurvey,
        columns: [columnId, columnScore, columnDate],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return DepressionSurvey.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<List<DepressionSurvey>> getAll() async {
    var db = await DatabaseProvider().database;
    List<Map> maps = await db.query(tableDepressionSurvey);
    List<DepressionSurvey> result =
        <DepressionSurvey>[];
    maps.forEach(
        (row) => result.add(DepressionSurvey.fromMap(row)));
    return result;
  }

  @override
  Future<int> delete(int id) async {
    var db = await DatabaseProvider().database;
    return await db.delete(tableDepressionSurvey,
        where: '$columnId = ?', whereArgs: [id]);
  }

  @override
  Future<int> updateTest(DepressionSurvey test) async {
    var db = await DatabaseProvider().database;
    return await db.update(tableDepressionSurvey, test.toMap(),
        where: '$columnId = ?', whereArgs: [test.id]);
  }

  @override
  Future<List<DepressionSurvey>> getBetweenDates(
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
                .subtract(DepressionSurvey.testInterval)
                .compareTo(creativityProductivitySurveys.last.date) >
            0;
  }

  @override
  Future<DepressionSurvey> insertIfActive(
      DepressionSurvey test, DateTime date) async {
    var db = await DatabaseProvider().database;
    List<Map> maps = await db.query(tableDepressionSurvey);
    List<DepressionSurvey> result =
        <DepressionSurvey>[];
    maps.forEach(
        (row) => result.add(DepressionSurvey.fromMap(row)));
    result.sort((a, b) => a.date.compareTo(b.date));
    if (result.length == 0 ||
        date.subtract(DepressionSurvey.testInterval).compareTo(result.last.date) > 0) {
      test.id =
          await db.insert(tableDepressionSurvey, test.toMap());
    }
    return test;
  }
}
