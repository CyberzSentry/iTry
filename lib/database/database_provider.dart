import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'models/tests/acuity_contrast_test.dart';
import 'models/tests/anxiety_survey.dart';
import 'models/tests/chronic_pain_survey.dart';
import 'models/tests/creativity_productivity_survey.dart';
import 'models/tests/creativity_productivity_test.dart';
import 'models/tests/depression_survey.dart';
import 'models/tests/finger_tapping_test.dart';
import 'models/tests/pavsat_test.dart';
import 'models/tests/spatial_memory_test.dart';
import 'models/tests/stress_survey.dart';



class DatabaseProvider {

  DatabaseProvider._();

  static final DatabaseProvider _instance = DatabaseProvider._();

  factory DatabaseProvider() {
    return _instance;
  }

  final String _databaseName = "iTry.db";

  Database _database;

  Future<Database> get database async {
    if (_database != null && _database?.isOpen == true) return _database;
    _database = await getDatabaseInstance();
    return _database;
  }

  Future<Database> getDatabaseInstance() async {
    var directoryPath = await getDatabasesPath();
    String fullPath = join(directoryPath, _databaseName);
    return await openDatabase(fullPath, version: 14,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
    );
  }

  //increment db version when changing
  Future _onCreate(Database db, int version) async {
        await db.execute(fingerTappingTestCreateString);
        await db.execute(creativityProductivitySurveyCreateString);
        await db.execute(creativityProductivityTestCreateString);
        await db.execute(spatialMemoryTestCreateString);
        await db.execute(depressionSurveyCreateString);
        await db.execute(stressSurveyCreateString);
        await db.execute(anxietySurveyCreateString);
        await db.execute(acuityContrastTestCreateString);
        await db.execute(pavsatTestCreateString);
        await db.execute(chronicPainSurveyCreateString);
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if(oldVersion < 14){
      await db.execute(chronicPainSurveyCreateString);
    }
    if(oldVersion < 13){
      await db.execute(acuityContrastTestDropString);
      await db.execute(acuityContrastTestCreateString);
    }
    if(oldVersion < 12){
      await db.execute(pavsatTestCreateString);
    }
    if(oldVersion < 11){
      await db.execute(acuityContrastTestCreateString);
    }
    if(oldVersion < 10){
      await db.execute(anxietySurveyCreateString);
    }
    if(oldVersion < 9){
      await db.execute(stressSurveyCreateString);
    }
    if(oldVersion < 8){
      await db.execute(depressionSurveyCreateString);
    }
  }

  Future resetDatabase() async {
    _database.close();
    var directoryPath = await getDatabasesPath();
    String fullPath = join(directoryPath, _databaseName);
    await deleteDatabase(fullPath);
  }
}