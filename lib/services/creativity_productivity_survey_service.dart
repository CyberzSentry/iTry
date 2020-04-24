import 'package:itry/database/database_provider.dart';
import 'package:itry/database/models/creativity_productivity_survey.dart';
import 'package:itry/database/models/creativity_productivity_survey.dart' as cpsurvey;

class CreativityProductivitySurveyService{

  CreativityProductivitySurveyService._();

  static final CreativityProductivitySurveyService _instance = CreativityProductivitySurveyService._();

  factory CreativityProductivitySurveyService() {
    return _instance;
  }

  Future<CreativityProductivitySurvey> insert(CreativityProductivitySurvey test) async {
    var db = await DatabaseProvider().database;
    test.id = await db.insert(tableCreativityProductivitySurvey, test.toMap());
    return test;
  }

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

  Future<List<CreativityProductivitySurvey>> getAll() async{
    var db = await DatabaseProvider().database;
    List<Map> maps = await db.query(tableCreativityProductivitySurvey);
    List<CreativityProductivitySurvey> result = <CreativityProductivitySurvey>[];
    maps.forEach((row) => result.add(CreativityProductivitySurvey.fromMap(row)));
    return result;
  }

  Future<int> delete(int id) async {
    var db = await DatabaseProvider().database;
    return await db.delete(tableCreativityProductivitySurvey, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> updateTest(CreativityProductivitySurvey test) async {
    var db = await DatabaseProvider().database;
    return await db.update(tableCreativityProductivitySurvey, test.toMap(),
        where: '$columnId = ?', whereArgs: [test.id]);
  }

  Future<List<CreativityProductivitySurvey>> getBetweenDates(DateTime from, DateTime to) async {
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
                .subtract(cpsurvey.testInterval)
                .compareTo(creativityProductivitySurveys.last.date) >
            0;
  }
}