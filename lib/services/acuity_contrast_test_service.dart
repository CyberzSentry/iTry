import 'package:itry/database/database_provider.dart';
import 'package:itry/database/models/acuity_contrast_test.dart';
import 'package:itry/services/test_service_interface.dart';

class AcuityContrastTestService
    implements TestServiceInterface<AcuityContrastTest> {
  
  AcuityContrastTestService();

  // AcuityContrastTestService._();

  // static final AcuityContrastTestService _instance =
  //     AcuityContrastTestService._();

  // factory AcuityContrastTestService() {
  //   return _instance;
  // }

  @override
  Future<AcuityContrastTest> insert(
      AcuityContrastTest test) async {
    var db = await DatabaseProvider().database;
    test.id = await db.insert(tableAcuityContrastTest, test.toMap());
    return test;
  }

  @override
  Future<AcuityContrastTest> getSingle(int id) async {
    var db = await DatabaseProvider().database;
    List<Map> maps = await db.query(tableAcuityContrastTest,
        columns: [columnId, columnScore, columnDate],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return AcuityContrastTest.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<List<AcuityContrastTest>> getAll() async {
    var db = await DatabaseProvider().database;
    List<Map> maps = await db.query(tableAcuityContrastTest);
    List<AcuityContrastTest> result = <AcuityContrastTest>[];
    maps.forEach((row) => result.add(AcuityContrastTest.fromMap(row)));
    return result;
  }

  @override
  Future<int> delete(int id) async {
    var db = await DatabaseProvider().database;
    return await db.delete(tableAcuityContrastTest,
        where: '$columnId = ?', whereArgs: [id]);
  }

  @override
  Future<int> updateTest(AcuityContrastTest test) async {
    var db = await DatabaseProvider().database;
    return await db.update(tableAcuityContrastTest, test.toMap(),
        where: '$columnId = ?', whereArgs: [test.id]);
  }

  @override
  Future<List<AcuityContrastTest>> getBetweenDates(
      DateTime from, DateTime to) async {
    var surveysList = await getAll();
    var surveysListFiltered = surveysList
        .where((x) =>
            DateTime.utc(x.date.year, x.date.month, x.date.day).compareTo(DateTime.utc(from.year, from.month, from.day)) >= 0 &&
            DateTime.utc(x.date.year, x.date.month, x.date.day).compareTo(DateTime.utc(to.year, to.month, to.day)) <= 0 )
        .toList();

    return surveysListFiltered;
  }

  @override
  Future<bool> isActive(DateTime date) async {
    var surveys = await getAll();
    surveys.sort((a, b) => a.date.compareTo(b.date));
    return surveys.length == 0 ||
        date.subtract(AcuityContrastTest.testInterval).compareTo(surveys.last.date) > 0;
  }

  @override
  Future<AcuityContrastTest> insertIfActive(
      AcuityContrastTest test, DateTime date) async {
    var db = await DatabaseProvider().database;
    List<Map> maps = await db.query(tableAcuityContrastTest);
    List<AcuityContrastTest> result = <AcuityContrastTest>[];
    maps.forEach((row) => result.add(AcuityContrastTest.fromMap(row)));
    result.sort((a, b) => a.date.compareTo(b.date));
    if (result.length == 0 ||
        date.subtract(AcuityContrastTest.testInterval).compareTo(result.last.date) > 0) {
      test.id = await db.insert(tableAcuityContrastTest, test.toMap());
    }
    return test;
  }
}
