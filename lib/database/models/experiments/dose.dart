import 'package:itry/database/models/experiments/experiment.dart' as exp;

final String tableDose = 'doses';
final String columnId = '_id';
final String columnDate = 'date';
final String columnValue = 'value';
final String columnExperimentId = 'experimentId';

final String experimentTable = exp.tableExperiment;
final String experimentId = exp.columnId;

final String doseCreateString = '''
              CREATE TABLE $tableDose (
                $columnId INTEGER PRIMARY KEY,
                $columnDate TEXT NOT NULL,
                $columnValue REAL NOT NULL,
                $columnExperimentId INTEGER NOT NULL,
                FOREIGN KEY ($columnExperimentId)
                  REFERENCES $experimentTable ($experimentId)
                    ON DELETE CASCADE
              )
              ''';

class Dose{
  int id;
  DateTime date;
  double value;
  int experimentId;

  Dose();

  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{
      columnDate: date.toIso8601String(),
      columnValue: value,
      columnExperimentId: experimentId,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  Dose.fromMap(Map<String, dynamic> map){
    id = map[columnId];
    date = DateTime.parse(map[columnDate]);
    value = map[columnValue];
    experimentId = map[columnExperimentId];
  }                                                                                                                                                                                             
}