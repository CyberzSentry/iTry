import 'package:itry/database/database_provider.dart';
import 'package:itry/database/models/experiments/experiment.dart';

class ExperimentService {
  ExperimentService();

  Future<Experiment> insert(Experiment experiment) async {
    var db = await DatabaseProvider().database;
    experiment.id = await db.insert(tableExperiment, experiment.toMap());
    return experiment;
  }

  Future<List<Experiment>> getAll() async {
    var db = await DatabaseProvider().database;
    List<Map> maps = await db.query(tableExperiment);
    List<Experiment> result = <Experiment>[];
    maps.forEach((row) => result.add(Experiment.fromMap(row)));
    return result;
  }

  Future<Experiment> getSingle(int id) async {
    var db = await DatabaseProvider().database;
    List<Map> maps = await db.query(tableExperiment,
        columns: [columnId, columnName, columnDescription, columnUnit, columnBaselineFrom, columnBaselineTo],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Experiment.fromMap(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    var db = await DatabaseProvider().database;
    return await db.delete(tableExperiment,
        where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> updateExperiment(Experiment test) async {
    var db = await DatabaseProvider().database;
    return await db.update(tableExperiment, test.toMap(),
        where: '$columnId = ?', whereArgs: [test.id]);
  }
}
