import 'package:itry/database/database_provider.dart';
import 'package:itry/database/models/tests/test_interface.dart';
import 'package:itry/services/tests/test_service_interface.dart';

abstract class BaseTestService<Test extends TestInterface>
    implements TestServiceInterface<Test> {
  @override
  String idCol = '_id';

  @override
  Future<Test> insert(
      Test test) async {
    var db = await DatabaseProvider().database;
    test.id = await db.insert(testTable, test.toMap());
    return test;
  }

  @override
  Future<int> delete(int id) async {
    var db = await DatabaseProvider().database;
    return await db.delete(testTable,
        where: '$idCol = ?', whereArgs: [id]);
  }

  @override
  Future<List<Test>> getBetweenDates(
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
  Future<int> updateTest(Test test) async {
    var db = await DatabaseProvider().database;
    return await db.update(testTable, test.toMap(),
        where: '$idCol = ?', whereArgs: [test.id]);
  }

  @override
  Future<bool> isActive(DateTime date) async {
    var surveys = await getAll();
    surveys.sort((a, b) => a.date.compareTo(b.date));
    return surveys.length == 0 ||
        date.subtract(duration).compareTo(surveys.last.date) > 0;
  }

}
