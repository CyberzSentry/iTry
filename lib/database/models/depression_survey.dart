import 'package:itry/database/models/test_interface.dart';

const String tableDepressionSurvey =
    'depressionSurveys';
const String columnId = '_id';
const String columnScore = 'score';
const String columnDate = 'date';

const String depressionSurveyCreateString = '''
              CREATE TABLE $tableDepressionSurvey (
                $columnId INTEGER PRIMARY KEY,
                $columnScore INTEGER NOT NULL,
                $columnDate TEXT NOT NULL
              )
              ''';

const int maxScore = 24;

const questionsMultiAns = <String>[
  'How often have you been bothered by feeling down, depressed or hopeless?',
  'How often have you had little interest or pleasure in doing things?',
  'How often have you been bothered by trouble falling or staying asleep, or sleeping too much?',
  'How often have you been bothered by feeling tired or having little energy?',
  'How often have you been bothered by poor appetite or overeating?',
  'How often have you been bothered by feeling bad about yourself, or that you are a failure, or have let yourself or your family down?',
  'How often have you been bothered by trouble concentrating on things, such as reading the newspaper or watching television?',
  'How often have you been bothered by moving or speaking so slowly that other people could have noticed, or the opposite - being so fidgety or restless that you have been moving around a lot more than usual?'
];

const possibleAnswers = <String>[
  'Not at all',
  'From time to time',
  'Most of the time',
  'Nearly all the time'
];

int calculateScore(List<int> answers){
  int sum = maxScore;
  for(var value in answers){
    sum -= value;
  }
  return sum;
}

class DepressionSurvey implements TestInterface {
  int id;
  int score;
  DateTime date;

  static const Duration testInterval = Duration(days: 7);

  double get percentageScore {
    return score / maxScore;
  }

  DepressionSurvey();

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

  DepressionSurvey.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    score = map[columnScore];
    date = DateTime.parse(map[columnDate]);
  }

  @override
  Duration getTestInterval() {
    return DepressionSurvey.testInterval;
  }
}
