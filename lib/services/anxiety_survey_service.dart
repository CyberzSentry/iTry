import 'package:itry/database/database_provider.dart';
import 'package:itry/database/models/anxiety_survey.dart';
import 'package:itry/services/test_service_interface.dart';

class AnxietySurveyService
    implements TestServiceInterface<AnxietySurvey> {
  AnxietySurveyService._();

  static final AnxietySurveyService _instance =
      AnxietySurveyService._();

  factory AnxietySurveyService() {
    return _instance;
  }

  @override
  Future<AnxietySurvey> insert(
      AnxietySurvey test) async {
    var db = await DatabaseProvider().database;
    test.id = await db.insert(tableAnxietySurvey, test.toMap());
    return test;
  }

  @override
  Future<AnxietySurvey> getSingle(int id) async {
    var db = await DatabaseProvider().database;
    List<Map> maps = await db.query(tableAnxietySurvey,
        columns: [columnId, columnScore, columnDate],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return AnxietySurvey.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<List<AnxietySurvey>> getAll() async {
    var db = await DatabaseProvider().database;
    List<Map> maps = await db.query(tableAnxietySurvey);
    List<AnxietySurvey> result =
        <AnxietySurvey>[];
    maps.forEach(
        (row) => result.add(AnxietySurvey.fromMap(row)));
    return result;
  }

  @override
  Future<int> delete(int id) async {
    var db = await DatabaseProvider().database;
    return await db.delete(tableAnxietySurvey,
        where: '$columnId = ?', whereArgs: [id]);
  }

  @override
  Future<int> updateTest(AnxietySurvey test) async {
    var db = await DatabaseProvider().database;
    return await db.update(tableAnxietySurvey, test.toMap(),
        where: '$columnId = ?', whereArgs: [test.id]);
  }

  @override
  Future<List<AnxietySurvey>> getBetweenDates(
      DateTime from, DateTime to) async {
    var creativityProductivityList = await getAll();
    var creativityProductivityListFiltered = creativityProductivityList
        .where((x) =>
            x.date.isAfter(from.add(Duration(days: -1))) &
            x.date.isBefore(to.add(Duration(days: 1))))
        .toList();

    return creativityProductivityListFiltered;
  }

  @override
  Future<bool> isActive(DateTime date) async {
    var creativityProductivitySurveys = await getAll();
    creativityProductivitySurveys.sort((a, b) => a.date.compareTo(b.date));
    return creativityProductivitySurveys.length == 0 ||
        date
                .subtract(AnxietySurvey.testInterval)
                .compareTo(creativityProductivitySurveys.last.date) >
            0;
  }

  @override
  Future<AnxietySurvey> insertIfActive(
      AnxietySurvey test, DateTime date) async {
    var db = await DatabaseProvider().database;
    List<Map> maps = await db.query(tableAnxietySurvey);
    List<AnxietySurvey> result =
        <AnxietySurvey>[];
    maps.forEach(
        (row) => result.add(AnxietySurvey.fromMap(row)));
    result.sort((a, b) => a.date.compareTo(b.date));
    if (result.length == 0 ||
        date.subtract(AnxietySurvey.testInterval).compareTo(result.last.date) > 0) {
      test.id =
          await db.insert(tableAnxietySurvey, test.toMap());
    }
    return test;
  }
}
