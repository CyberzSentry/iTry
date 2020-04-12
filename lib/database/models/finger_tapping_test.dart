final String tableFingerTappingTests = 'fingerTappingTests';
final String columnId = '_id';
final String columnScore = 'score';
final String columnDate = 'date';

final String fingerTappingTestCreateString = '''
              CREATE TABLE $tableFingerTappingTests (
                $columnId INTEGER PRIMARY KEY,
                $columnScore INTEGER NOT NULL,
                $columnDate TEXT NOT NULL
              )
              ''';

final int maxScore = 100;

class FingerTappingTest{
  int id;
  int score;
  DateTime date;

  double get percentageScore {
    return score / maxScore;
  }

  FingerTappingTest();

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

  FingerTappingTest.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    score = map[columnScore];
    date = DateTime.parse(map[columnDate]);
  }
}