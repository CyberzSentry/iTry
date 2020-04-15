final String tableCreativityProductivitySurvey = 'creativityProductivitySurveys';
final String columnId = '_id';
final String columnScore = 'score';
final String columnDate = 'date';

final String creativityProductivitySurveyCreateString = '''
              CREATE TABLE $tableCreativityProductivitySurvey (
                $columnId INTEGER PRIMARY KEY,
                $columnScore INTEGER NOT NULL,
                $columnDate TEXT NOT NULL
              )
              ''';

final int maxScore = 12;

final Duration testInterval = Duration(days: 1);

class CreativityProductivitySurvey{
  int id;
  int score;
  DateTime date;

   double get percentageScore {
    return score / maxScore;
  }

  CreativityProductivitySurvey();

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

  CreativityProductivitySurvey.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    score = map[columnScore];
    date = DateTime.parse(map[columnDate]);
  }
}