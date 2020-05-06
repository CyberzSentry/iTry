import 'package:itry/database/models/test_interface.dart';

final String tableAcuityContrastTest = 'acuityContrastTests';
final String columnId = '_id';
final String columnScore = 'score';
final String columnDate = 'date';

final String acuityContrastTestCreateString = '''
              CREATE TABLE $tableAcuityContrastTest (
                $columnId INTEGER PRIMARY KEY,
                $columnScore INTEGER NOT NULL,
                $columnDate TEXT NOT NULL
              )
              ''';

final int maxScore = 14;

class AcuityContrastTest implements TestInterface {
  int id;
  int score;
  DateTime date;
  static final Duration testInterval = Duration(days: 14);

  double get percentageScore {
    return ((score / maxScore) * 100);
  }

  AcuityContrastTest();

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

  AcuityContrastTest.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    score = map[columnScore];
    date = DateTime.parse(map[columnDate]);
  }

  @override
  Duration getTestInterval() {
    return AcuityContrastTest.testInterval;
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
