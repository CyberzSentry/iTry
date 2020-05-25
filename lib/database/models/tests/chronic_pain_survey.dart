

import 'package:itry/database/models/tests/test_interface.dart';

const String tableChronicPainSurvey = 'chronicPainSurveys';
const String columnId = '_id';
const String columnScore = 'score';
const String columnDate = 'date';

const String chronicPainSurveyCreateString = '''
              CREATE TABLE $tableChronicPainSurvey (
                $columnId INTEGER PRIMARY KEY,
                $columnScore INTEGER NOT NULL,
                $columnDate TEXT NOT NULL
              )
              ''';

const int maxScore = 27;

const questionsMulti = <List<String>>[
  <String>[
    'During the past week, have you had any pain or would you have had pain if not for the treatment you are receiving?',
    'Do you have periods during the day when you have temporary episodes of uncontrolled pain (also known as breakthrough pain)?',
    'Does the pain affect your ability to handle daily responsibilities at home or work?'
  ],
  <String>[
    'During the past week, on average, how would you rate your baseline pain?',
  ],
  <String>[
    'To what extent does avoiding activities due to fear of a pain compromise your quality of life?',
  ],
  <String>[
    'How your pain interfered with your sleep this past week?',
    'How your pain interfered with your mood this past week?',
  ],
  <String>[
    'Did you have trouble thinking or remembering in the past week?',
  ],
  <String>[
    'Were you sensitive to such things as bright lights or loud noises or smells in the past week?',
  ],
];

const possibleAnswersMulti = <List<String>>[
  <String>['No', 'Yes'],
  <String>[
    'Mild pain',
    'Moderate pain',
    'severe pain',
  ],
  <String>['Not at all', 'A little', 'A lot'],
  <String>['Not at all', 'Interfered to some point', 'Completely interfered'],
  <String>['No trouble', 'A little trouble', 'Severe trouble'],
  <String>['Not at all', 'A little', 'Very much'],
];

int calculateScore(List<List<int>> answersMulti) {
  answersMulti = answersMulti.toList();

  if (answersMulti[0][0] == 0) {
    return 0;
  } else {
    int sum = 0;

    for(var ans in answersMulti[0]){
      sum += ans * 3;
    }
    sum += answersMulti[1][0] + 1;
    sum += answersMulti[2][0] + 1;
    for(var ans in answersMulti[3]){
      sum += ans +1;
    }
    sum += answersMulti[4][0] + 1;
    sum += answersMulti[5][0] + 1;

    return sum;
  }
}

class ChronicPainSurvey implements TestInterface {
  int id;
  int score;
  DateTime date;

  static const Duration testInterval = Duration(days: 7);

  double get percentageScore {
    return ((score / maxScore) * 100);
  }

  ChronicPainSurvey();

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

  ChronicPainSurvey.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    score = map[columnScore];
    date = DateTime.parse(map[columnDate]);
  }

  @override
  Duration getTestInterval() {
    return ChronicPainSurvey.testInterval;
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
