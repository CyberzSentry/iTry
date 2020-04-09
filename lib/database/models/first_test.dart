
final String tableTests = 'tests';
final String columnId = '_id';
final String columnScore = 'score';
final String columnDate = 'date';

final String firstTestCreateString = '''
              CREATE TABLE $tableTests (
                $columnId INTEGER PRIMARY KEY,
                $columnScore INTEGER NOT NULL,
                $columnDate TEXT NOT NULL
              );
              ''';

class FirstTest {
  int id;
  int score;
  DateTime date;

  FirstTest();

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

  FirstTest.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    score = map[columnScore];
    date = DateTime.parse(map[columnDate]);
  }
}