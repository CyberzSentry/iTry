import 'package:itry/database/database_provider.dart';
import 'package:itry/database/models/tests/anxiety_survey.dart';
import 'package:itry/services/tests/base_test_service.dart';
import 'package:itry/services/tests/test_service_interface.dart';

class AnxietySurveyService extends BaseTestService<AnxietySurvey>
    implements TestServiceInterface<AnxietySurvey> {
  
  AnxietySurveyService();

  @override
  Duration duration = AnxietySurvey.testInterval;

  @override
  String testTable = tableAnxietySurvey;

  @override
  Future<AnxietySurvey> getSingle(int id) async {
    var db = await DatabaseProvider().database;
    List<Map> maps = await db.query(testTable,
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
    List<Map> maps = await db.query(testTable);
    List<AnxietySurvey> result =
        <AnxietySurvey>[];
    maps.forEach(
        (row) => result.add(AnxietySurvey.fromMap(row)));
    return result;
  }

  @override
  Future<AnxietySurvey> insertIfActive(
      AnxietySurvey test, DateTime date) async {
    var db = await DatabaseProvider().database;
    List<Map> maps = await db.query(testTable);
    List<AnxietySurvey> result =
        <AnxietySurvey>[];
    maps.forEach(
        (row) => result.add(AnxietySurvey.fromMap(row)));
    result.sort((a, b) => a.date.compareTo(b.date));
    if (result.length == 0 ||
        date.subtract(AnxietySurvey.testInterval).compareTo(result.last.date) > 0) {
      test.id =
          await db.insert(testTable, test.toMap());
    }
    return test;
  }
}
