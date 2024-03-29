

import 'package:itry/database/models/tests/test_interface.dart';

final String tableSpatialMemoryTests = 'spatialMemoryTests';
final String columnId = '_id';
final String columnScore = 'score';
final String columnDate = 'date';

final String spatialMemoryTestCreateString = '''
              CREATE TABLE $tableSpatialMemoryTests (
                $columnId INTEGER PRIMARY KEY,
                $columnScore INTEGER NOT NULL,
                $columnDate TEXT NOT NULL
              )
              ''';

final int maxScore = 2 * series.length;



int calculateScore(List<int> goodAnswers){
  int score = 0;
  
  for(int i=0; i<goodAnswers.length;i++){
    if(goodAnswers[i] == series[i]){
      score += 2;
    }else if (goodAnswers[i] / series[i] > partialScoreStep){
      score += 1;
    }
  }

  return score;
}

final List<int> series = [5, 8, 10];

final int enabledMs = 1000;
final int disabledMs = 1000;
final double partialScoreStep = 0.5;

class SpatialMemoryTest implements TestInterface{
  int id;
  int score;
  DateTime date;

  static final Duration testInterval = Duration(days: 7);

   double get percentageScore {
    return (score / maxScore)*100;
  }

  SpatialMemoryTest();

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

  SpatialMemoryTest.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    score = map[columnScore];
    date = DateTime.parse(map[columnDate]);
  }

  @override
  Duration getTestInterval() {
    return SpatialMemoryTest.testInterval;
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