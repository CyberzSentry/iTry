import 'package:itry/database/database_provider.dart';
import 'package:itry/database/models/creativity_productivity_survey.dart';
import 'package:itry/services/tests/base_test_service.dart';
import 'package:itry/services/tests/test_service_interface.dart';

class CreativityProductivitySurveyService extends BaseTestService<CreativityProductivitySurvey>
    implements TestServiceInterface<CreativityProductivitySurvey> {
  
  CreativityProductivitySurveyService();

  @override
  Duration duration = CreativityProductivitySurvey.testInterval;

  @override
  String testTable = tableCreativityProductivitySurvey;

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
