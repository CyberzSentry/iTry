

import 'package:itry/database/models/tests/test_interface.dart';

const String tableAnxietySurvey = 'anxietySurveys';
const String columnId = '_id';
const String columnScore = 'score';
const String columnDate = 'date';

const String anxietySurveyCreateString = '''
              CREATE TABLE $tableAnxietySurvey (
                $columnId INTEGER PRIMARY KEY,
                $columnScore INTEGER NOT NULL,
                $columnDate TEXT NOT NULL
              )
              ''';

const int maxScore = 30;

const questionsMulti = <List<String>>[
  <String>[
    'How often have you been bothered by feeling nervous, anxious or on edge?',
    'How often have you been bothered by not being able to stop or control worrying?',
    'How often have you been bothered by worrying too much about different things?',
    'How often have you been bothered by having trouble relaxing?',
    'How often have you been bothered by being so restless that it is hard to sit still?',
    'How often have you been bothered by becoming easily annoyed or irritable?',
    'How often have you been bothered by feeling afraid as if something awful might happen?',
  ],
  <String>['Have you had an anxiety attack (suddenly feeling fear or panic)?'],
];

const possibleAnswersMulti = <List<String>>[
  <String>[
    'Not at all',
    'From time to time',
    'Most of the time',
    'Nearly all the time'
  ],
  <String>[
    'No',
    'Yes',
  ],
  <String>[
    'Not difficult at all',
    'Somewhat difficult',
    'Very difficult',
    'Extremely difficult'
  ],
];

const additionalToCheck = <List<String>>[
  <String>[
    'If this questionnaire has highlighted any problems, how difficult have these problems made it for you to do your work, take care of things at home, or get along with other people?'
  ],
];

const additionalToCheckAns = <List<String>>[
  <String>[
    'Not difficult at all',
    'Somewhat difficult',
    'Very difficult',
    'Extremely difficult'
  ],
];

const questionsCheck = <String>[
  'Have you been bothered by worrying about any of the following?'
];

const possibleAnswersCheck = <List<String>>[
  <String>[
    'Your health',
    'Your weight or how you look',
    'Little or no sexual desire or pleasure during sex',
    'Difficulties with your partner',
    'The stress of taking care of family members',
    'Stress at work, school or outside home',
    'By financial problems or worries',
    'Having no one to turn to',
    'Something bad that happened recently'
  ],
];

int calculateScore(List<List<int>> answersMulti, List<List<bool>> answersCheck,
    List<List<int>> additional) {
  answersMulti = answersMulti.toList();
  answersCheck = answersCheck.toList();
  additional = additional.toList();

  int sum = 0;
  for (var ans in answersMulti[0]) {
    sum += ans;
  }
  sum += answersMulti[1][0] * 3;

  int sumBool = 0;

  for (var ans in answersCheck[0]) {
    if (ans == true) {
      sumBool++;
    }
  }

  if (sumBool == 0) {
    sum += 0;
  } else if (sumBool < 4) {
    sum += 1;
  } else if (sumBool < 7) {
    sum += 2;
  } else {
    sum += 3;
  }

  sum += additional[0][0];

  return sum;
}

class AnxietySurvey implements TestInterface {
  int id;
  int score;
  DateTime date;

  static const Duration testInterval = Duration(days: 7);

  double get percentageScore {
    return ((score / maxScore) * 100);
  }

  AnxietySurvey();

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

  AnxietySurvey.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    score = map[columnScore];
    date = DateTime.parse(map[columnDate]);
  }

  @override
  Duration getTestInterval() {
    return AnxietySurvey.testInterval;
  }

  @override
  String toString() {
    var percentageRounded = percentageScore.toStringAsFixed(2);

    return "Score: $score, Percentage score: $percentageRounded%";
  }

  @override
  double compareResults(TestInterface test) {
    return (this.percentageScore - test.percentageScore) == 0
        ? (this.percentageScore - test.percentageScore)
        : (this.percentageScore - test.percentageScore) * -1;
  }
}
