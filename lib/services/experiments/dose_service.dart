import 'package:itry/database/database_provider.dart';
import 'package:itry/database/models/experiments/dose.dart';


class DoseService{
  DoseService();

  Future<Dose> insert(Dose dose) async {
    var db = await DatabaseProvider().database;
    dose.id = await db.insert(tableDose, dose.toMap());
    return dose;
  }

  Future<List<Dose>> getAll() async {
    var db = await DatabaseProvider().database;
    List<Map> maps = await db.query(tableDose);
    List<Dose> result = <Dose>[];
    maps.forEach((row) => result.add(Dose.fromMap(row)));
    return result;
  }

  Future<List<Dose>> getAllFromExperiment(int experimentId) async {
    var db = await DatabaseProvider().database;
    List<Map> maps = await db.query(tableDose, 
    where: "$columnExperimentId = ?",
    whereArgs: [experimentId]);
    List<Dose> result = <Dose>[];
    maps.forEach((row) => result.add(Dose.fromMap(row)));
    return result;
  }
}