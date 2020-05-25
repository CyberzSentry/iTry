

import 'package:itry/database/models/tests/test_interface.dart';

final String tablePavsatTests = 'pavsatTests';
final String columnId = '_id';
final String columnScore = 'score';
final String columnDate = 'date';

final String pavsatTestCreateString = '''
              CREATE TABLE $tablePavsatTests (
                $columnId INTEGER PRIMARY KEY,
                $columnScore INTEGER NOT NULL,
                $columnDate TEXT NOT NULL
              )
              ''';

final int maxScore = 60;

class PavsatTest implements TestInterface{
  int id;
  int score;
  DateTime date;

  static final Duration testInterval = Duration(days: 14);

   double get percentageScore {
    return (score / maxScore)*100;
  }

  PavsatTest();

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

  PavsatTest.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    score = map[columnScore];
    date = DateTime.parse(map[columnDate]);
  }

  @override
  Duration getTestInterval() {
    return PavsatTest.testInterval;
  }

  @override
  String toString() {
    var percentageRounded = percentageScore.toStringAsFixed(2);

    return "Score: $score, Percentage score: $percentageRounded%";
  }

  @override
  double compareResults(TestInterface test) {
    return this.percentageScore - test.percentageScore;
  }
}