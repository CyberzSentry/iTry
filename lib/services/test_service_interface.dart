abstract class TestServiceInterface<T>{
  
  Future<T> insert(T test);

  Future<T> insertIfActive(T test, DateTime date);

  Future<T> getSingle(int id);

  Future<List<T>> getAll();

  Future<int> delete(int id);

  Future<int> updateTest(T test);

  Future<List<T>> getBetweenDates(DateTime from, DateTime to);

  Future<bool> isActive(DateTime date);
}