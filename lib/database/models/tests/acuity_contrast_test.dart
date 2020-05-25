

import 'package:itry/database/models/tests/test_interface.dart';

final String tableAcuityContrastTest = 'acuityContrastTests';
final String columnId = '_id';
final String columnScoreLeft = 'scoreLeft';
final String columnScoreRight = 'scoreRight';
final String columnDate = 'date';

final String acuityContrastTestCreateString = '''
              CREATE TABLE $tableAcuityContrastTest (
                $columnId INTEGER PRIMARY KEY,
                $columnScoreLeft INTEGER NOT NULL,
                $columnScoreRight INTEGER NOT NULL,
                $columnDate TEXT NOT NULL
              )
              ''';

final String acuityContrastTestDropString =
    '''DROP TABLE IF EXISTS $tableAcuityContrastTest''';

final int maxScore = 16;

class AcuityContrastTest implements TestInterface {
  int id;
  int scoreLeft;
  int scoreRight;
  DateTime date;
  static final Duration testInterval = Duration(days: 14);

  double get percentageScore {
    return (((scoreLeft + scoreRight) / 2 / maxScore) * 100);
  }

  AcuityContrastTest();

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnScoreLeft: scoreLeft,
      columnScoreRight: scoreRight,
      columnDate: date.toIso8601String(),
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  AcuityContrastTest.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    scoreLeft = map[columnScoreLeft];
    scoreRight = map[columnScoreRight];
    date = DateTime.parse(map[columnDate]);
  }

  @override
  Duration getTestInterval() {
    return AcuityContrastTest.testInterval;
  }

  @override
  String toString() {
    var percentageRounded = percentageScore.toStringAsFixed(2);

    return "Score left: $scoreLeft, Score right: $scoreRight Percentage score: $percentageRounded%";
  }

  @override
  double compareResults(TestInterface test) {
    return this.percentageScore - test.percentageScore;
  }
}
