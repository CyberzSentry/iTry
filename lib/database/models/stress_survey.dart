import 'package:itry/database/models/test_interface.dart';

const String tableStressSurvey =
    'stressSurveys';
const String columnId = '_id';
const String columnScore = 'score';
const String columnDate = 'date';

const String stressSurveyCreateString = '''
              CREATE TABLE $tableStressSurvey (
                $columnId INTEGER PRIMARY KEY,
                $columnScore INTEGER NOT NULL,
                $columnDate TEXT NOT NULL
              )
              ''';

const int maxScore = 24;

const questionsMultiAns = <String>[
  'How often have you been bothered by trouble falling or staying asleep, or sleeping too much?',
  'How often have you been bothered by poor appetite or overeating?',
  'How often have you been bothered by becoming easily annoyed or irritable?',
  'How often have you experienced any of the following symptoms: headaches, chest pain, muscle tension, nausea, or changes in sex drive?',
  'How often have you worried excessively and feel overwhelmed with responsibilities?',
  'How often have you struggled to focus on tasks or stay motivated?',
  'How often have you struggled to regulate how much caffeine, alcohol, or tobacco you use?',
  'How often have you withdraw from others or feel overwhelmed in groups of people?',
];

const possibleAnswers = <String>[
  'Not at all',
  'From time to time',
  'Most of the time',
  'Nearly all the time'
];

int calculateScore(List<int> answers){
  int sum = 0;
  for(var value in answers){
    sum += value;
  }
  return sum;
}

class StressSurvey implements TestInterface {
  int id;
  int score;
  DateTime date;

  static const Duration testInterval = Duration(days: 7);

  double get percentageScore {
    return score / maxScore;
  }

  StressSurvey();

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

  StressSurvey.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    score = map[columnScore];
    date = DateTime.parse(map[columnDate]);
  }

  @override
  Duration getTestInterval() {
    return StressSurvey.testInterval;
  }

  @override
  String toString() {
    var percentageRounded = percentageScore.toStringAsFixed(2);

    return "Score: $score, Percentage score: $percentageRounded%";
  }
}
