import 'package:itry/database/database_provider.dart';
import 'package:itry/database/models/depression_survey.dart';
import 'package:itry/services/tests/base_test_service.dart';
import 'package:itry/services/tests/test_service_interface.dart';


class DepressionSurveyService extends BaseTestService<DepressionSurvey>
    implements TestServiceInterface<DepressionSurvey> {
  
  DepressionSurveyService();

  
  @override
  Duration duration = DepressionSurvey.testInterval;

  @override
  String testTable = tableDepressionSurvey;

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
