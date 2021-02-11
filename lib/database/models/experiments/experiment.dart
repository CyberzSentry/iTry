final String tableExperiment = 'experiments';
final String columnId = '_id';
final String columnName = 'name';
final String columnDescription = 'description';
final String columnUnit = 'unit';
final String columnBaselineFrom = 'baselineFrom';
final String columnBaselineTo = 'baselineTo';

final String experimentCreateString = '''
              CREATE TABLE $tableExperiment (
                $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
                $columnName TEXT NOT NULL,
                $columnDescription TEXT NOT NULL,
                $columnUnit INTEGER NOT NULL,
                $columnBaselineFrom TEXT NULL,
                $columnBaselineTo TEXT NULL
              )
              ''';

class Experiment{
  int id;
  ExperimentUnits unit;
  String name;
  String description;
  DateTime baselineFrom;
  DateTime baselineTo;

  Experiment(){
    name = "";
    description = "";
  }

  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{
      columnName: name,
      columnDescription: description,
      columnUnit: unit.index,
      columnBaselineFrom: baselineFrom?.toIso8601String(),
      columnBaselineTo: baselineTo?.toIso8601String()
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  Experiment.fromMap(Map<String, dynamic> map){
    id = map[columnId];
    name = map[columnName];
    unit = ExperimentUnits.values[map[columnUnit]];
    description = map[columnDescription];
    var colBsF = map[columnBaselineFrom];
    if(colBsF != null){
      baselineFrom = DateTime.parse(map[columnBaselineFrom]);
    }
    var colBsT = map[columnBaselineTo];
    if(colBsT != null){
      baselineTo = DateTime.parse(map[columnBaselineTo]);
    }
  }
}

enum ExperimentUnits{
  ounces,
  pounds,
  kgrams,
  grams,
  mgrams,
  days,
  hours,
  minutes,
  kmeters,
  miles,
  count,
}

extension ExperimentExtension on ExperimentUnits{
  String stringValue(){
    switch(this){
      case ExperimentUnits.ounces:
        return "Ounces";
      case ExperimentUnits.pounds:
        return "Pounds";
      case ExperimentUnits.kgrams:
        return "Kilograms";
      case ExperimentUnits.grams:
        return "Grams";
      case ExperimentUnits.mgrams:
        return "Miligrams";
      case ExperimentUnits.days:
        return "Days";
      case ExperimentUnits.hours:
        return "Hours";
      case ExperimentUnits.minutes:
        return "Minutes";
      case ExperimentUnits.kmeters:
        return "Kilometers";
      case ExperimentUnits.miles:
        return "Miles";
      case ExperimentUnits.count:
        return "Count";
      default:
        return null;
    }
  }
}