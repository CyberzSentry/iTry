import 'package:itry/database/models/test_interface.dart';

final String tableCreativityProductivitySurvey =
    'creativityProductivitySurveys';
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

final int maxScore = 18;

final questionsMultiAns = <String>[
  'Have you been creative this past week?',
  'Have you been contemplative this past week?',
  'Have you been focused this past week?',
  'Have you been productive this past week?',
  'Have you experienced fatigue due to lack of sleep this past week?',
  'Have you been distracted due to some unusual event this past week?',
];

final possibleAnswers = <String>[
  'Not at all',
  'From time to time',
  'Most of the time',
  'Nearly all the time'
];

int calculateScore(List<int> answers){
  answers[4] = answers[4] * -1;
  answers[5] = answers[5] * -1;
  var sum = 0;
  for (var val in answers) {
    sum += val;
  }
  return sum + 6;
}

class CreativityProductivitySurvey implements TestInterface {
  int id;
  int score;
  DateTime date;

  static final Duration testInterval = Duration(days: 7);

  double get percentageScore {
    return ((score / maxScore ) *100);
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

  @override
  Duration getTestInterval() {
    return CreativityProductivitySurvey.testInterval;
  }

  @override
  String toString() {
    var percentageRounded = percentageScore.toStringAsFixed(2);

    return "Score: $score, Percentage score: $percentageRounded%";
  }
}
