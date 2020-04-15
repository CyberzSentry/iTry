import 'package:itry/database/database_provider.dart';
import 'package:itry/database/models/creativity_productivity_survey.dart';

class CreativityProductivitySurveyAccesor{

  Future<CreativityProductivitySurvey> insert(CreativityProductivitySurvey test) async {
    var db = await DatabaseProvider.db.database;
    test.id = await db.insert(tableCreativityProductivitySurvey, test.toMap());
    return test;
  }

  Future<CreativityProductivitySurvey> getSingle(int id) async {
    var db = await DatabaseProvider.db.database;
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
    var db = await DatabaseProvider.db.database;
    List<Map> maps = await db.query(tableCreativityProductivitySurvey);
    List<CreativityProductivitySurvey> result = <CreativityProductivitySurvey>[];
    maps.forEach((row) => result.add(CreativityProductivitySurvey.fromMap(row)));
    return result;
  }

  Future<int> delete(int id) async {
    var db = await DatabaseProvider.db.database;
    return await db.delete(tableCreativityProductivitySurvey, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> updateTest(CreativityProductivitySurvey test) async {
    var db = await DatabaseProvider.db.database;
    return await db.update(tableCreativityProductivitySurvey, test.toMap(),
        where: '$columnId = ?', whereArgs: [test.id]);
  }
}