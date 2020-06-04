final String tableExperiment = 'experiments';
final String columnId = '_id';
final String columnName = 'name';
final String columnDescription = 'description';
final String columnUnit = 'unit';
//final String columnType = 'type';

final String experimentCreateString = '''
              CREATE TABLE $tableExperiment (
                $columnId INTEGER PRIMARY KEY,
                $columnName TEXT NOT NULL,
                $columnDescription TEXT NOT NULL,
                $columnUnit INTEGER NOT NULL
              )
              ''';

class Experiment{
  int id;
  ExperimentUnits unit;
  String name;
  String description;

  Experiment(){
    name = "";
    description = "";
  }

  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{
      columnName: name,
      columnDescription: description,
      columnUnit: unit.index,
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