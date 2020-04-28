import 'package:itry/database/models/test_interface.dart';

final String tableCreativityProductivityTest = 'creativityProductivityTests';
final String columnId = '_id';
final String columnScore = 'score';
final String columnDate = 'date';

final String creativityProductivityTestCreateString = '''
              CREATE TABLE $tableCreativityProductivityTest (
                $columnId INTEGER PRIMARY KEY,
                $columnScore INTEGER NOT NULL,
                $columnDate TEXT NOT NULL
              )
              ''';

final int maxScore = 60;

class CreativityProductivityTest implements TestInterface{
  int id;
  int score;
  DateTime date;
  static final Duration testInterval = Duration(days: 1);

   double get percentageScore {
    return score / maxScore;
  }

  CreativityProductivityTest();

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnScore: score,
      columnDate: date.toIso8601String(),
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  CreativityProductivityTest.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    score = map[columnScore];
    date = DateTime.parse(map[columnDate]);
  }

  @override
  Duration getTestInterval() {
    return CreativityProductivityTest.testInterval;
  }
}