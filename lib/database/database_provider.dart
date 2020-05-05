import 'package:itry/database/models/acuity_contrast_test.dart';
import 'package:itry/database/models/anxiety_survey.dart';
import 'package:itry/database/models/creativity_productivity_test.dart';
import 'package:itry/database/models/depression_survey.dart';
import 'package:itry/database/models/finger_tapping_test.dart';
import 'package:itry/database/models/creativity_productivity_survey.dart';
import 'package:itry/database/models/pavsat_test.dart';
import 'package:itry/database/models/spatial_memory_test.dart';
import 'package:itry/database/models/stress_survey.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';



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
    return await openDatabase(fullPath, version: 12,
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
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
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