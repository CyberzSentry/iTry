import 'package:itry/database/database_provider.dart';
import 'package:itry/database/models/tests/chronic_pain_survey.dart';
import 'package:itry/services/tests/base_test_service.dart';
import 'package:itry/services/tests/test_service_interface.dart';

class ChronicPainSurveyService extends BaseTestService<ChronicPainSurvey>
    implements TestServiceInterface<ChronicPainSurvey> {
  
  ChronicPainSurveyService();

  @override
  Duration duration = ChronicPainSurvey.testInterval;

  @override
  String testTable = tableChronicPainSurvey;

  @override
  Future<ChronicPainSurvey> getSingle(int id) async {
    var db = await DatabaseProvider().database;
    List<Map> maps = await db.query(testTable,
        columns: [columnId, columnScore, columnDate],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return ChronicPainSurvey.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<List<ChronicPainSurvey>> getAll() async {
    var db = await DatabaseProvider().database;
    List<Map> maps = await db.query(testTable);
    List<ChronicPainSurvey> result =
        <ChronicPainSurvey>[];
    maps.forEach(
        (row) => result.add(ChronicPainSurvey.fromMap(row)));
    return result;
  }

  @override
  Future<ChronicPainSurvey> insertIfActive(
      ChronicPainSurvey test, DateTime date) async {
    var db = await DatabaseProvider().database;
    List<Map> maps = await db.query(testTable);
    List<ChronicPainSurvey> result =
        <ChronicPainSurvey>[];
    maps.forEach(
        (row) => result.add(ChronicPainSurvey.fromMap(row)));
    result.sort((a, b) => a.date.compareTo(b.date));
    if (result.length == 0 ||
        date.subtract(ChronicPainSurvey.testInterval).compareTo(result.last.date) > 0) {
      test.id =
          await db.insert(testTable, test.toMap());
    }
    return test;
  }
}
