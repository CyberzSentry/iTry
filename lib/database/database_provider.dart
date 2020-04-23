import 'package:itry/database/models/finger_tapping_test.dart';
import 'package:itry/database/models/creativity_productivity_survey.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';



class DatabaseProvider {
  DatabaseProvider._();

  static final DatabaseProvider db = DatabaseProvider._();

  Database _database;
  final String _databaseName = "iTry.db";

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await getDatabaseInstance();
    return _database;
  }

  Future<Database> getDatabaseInstance() async {
    var directoryPath = await getDatabasesPath();
    String fullPath = join(directoryPath, _databaseName);
    return await openDatabase(fullPath, version: 4,
        onCreate: _onCreate
    );
  }

  Future _onCreate(Database db, int version) async {
        await db.execute(fingerTappingTestCreateString);
        await db.execute(creativityProductivitySurveyCreateString);
  }

}