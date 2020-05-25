import 'package:itry/database/database_provider.dart';
import 'package:itry/database/models/tests/stress_survey.dart';
import 'package:itry/services/tests/base_test_service.dart';
import 'package:itry/services/tests/test_service_interface.dart';

class StressSurveyService extends BaseTestService<StressSurvey>
    implements TestServiceInterface<StressSurvey> {
  StressSurveyService();

  @override
  Duration duration = StressSurvey.testInterval;

  @override
  String testTable = tableStressSurvey;

  @override
  Future<StressSurvey> getSingle(int id) async {
    var db = await DatabaseProvider().database;
    List<Map> maps = await db.query(testTable,
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
    List<Map> maps = await db.query(testTable);
    List<StressSurvey> result = <StressSurvey>[];
    maps.forEach((row) => result.add(StressSurvey.fromMap(row)));
    return result;
  }

  @override
  Future<StressSurvey> insertIfActive(StressSurvey test, DateTime date) async {
    var db = await DatabaseProvider().database;
    List<Map> maps = await db.query(testTable);
    List<StressSurvey> result = <StressSurvey>[];
    maps.forEach((row) => result.add(StressSurvey.fromMap(row)));
    result.sort((a, b) => a.date.compareTo(b.date));
    if (result.length == 0 ||
        date.subtract(StressSurvey.testInterval).compareTo(result.last.date) >
            0) {
      test.id = await db.insert(testTable, test.toMap());
    }
    return test;
  }
}
