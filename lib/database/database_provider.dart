import 'package:itry/database/models/creativity_productivity_test.dart';
import 'package:itry/database/models/finger_tapping_test.dart';
import 'package:itry/database/models/creativity_productivity_survey.dart';
import 'package:itry/database/models/spatial_memory_test.dart';
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
    if (_database != null) return _database;
    _database = await getDatabaseInstance();
    return _database;
  }

  Future<Database> getDatabaseInstance() async {
    var directoryPath = await getDatabasesPath();
    String fullPath = join(directoryPath, _databaseName);
    return await openDatabase(fullPath, version: 6,
        onCreate: _onCreate
    );
  }

  Future _onCreate(Database db, int version) async {
        await db.execute(fingerTappingTestCreateString);
        await db.execute(creativityProductivitySurveyCreateString);
        await db.execute(creativityProductivityTestCreateString);
        await db.execute(spatialMemoryTestCreateString);
  }
}