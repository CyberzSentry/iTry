

import 'package:itry/database/models/tests/test_interface.dart';

final String tableFingerTappingTests = 'fingerTappingTests';
final String columnId = '_id';
final String columnScoreDominant = 'scoreDominant';
final String columnScoreNonDominant = 'scoreNonDominant';
final String columnDate = 'date';

final String fingerTappingTestCreateString = '''
              CREATE TABLE $tableFingerTappingTests (
                $columnId INTEGER PRIMARY KEY,
                $columnScoreDominant INTEGER NOT NULL,
                $columnScoreNonDominant INTEGER NOT NULL,
                $columnDate TEXT NOT NULL
              )
              ''';

final int maxScore = 200;

class FingerTappingTest implements TestInterface{
  int id;
  int scoreDominant;
  int scoreNonDominant;
  DateTime date;
  static final Duration testInterval = Duration(days: 7);

  double get percentageScore {
    return (((scoreDominant + scoreNonDominant) / (maxScore *2)) *100);
  }

  FingerTappingTest();

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnScoreDominant: scoreDominant,
      columnScoreNonDominant: scoreNonDominant,
      columnDate: date.toIso8601String(),
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  FingerTappingTest.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    scoreDominant = map[columnScoreDominant];
    scoreNonDominant = map[columnScoreNonDominant];
    date = DateTime.parse(map[columnDate]);
  }

  @override
  Duration getTestInterval() {
    return FingerTappingTest.testInterval;
  }

  @override
  String toString() {
   var percentageRounded = percentageScore.toStringAsFixed(2);

    return "Score dominant: $scoreDominant, nondominant: $scoreNonDominant, Percentage score: $percentageRounded%";
  }

  @override
  double compareResults(TestInterface test) {
    return this.percentageScore - test.percentageScore;
  }
}