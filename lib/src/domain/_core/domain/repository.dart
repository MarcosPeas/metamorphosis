abstract class Repository<T> {
  Future<T> save(T entity);

  Future<T> update(T entity);

  Future<T> getById(String id);

  Future<List<T>> paginate(PaginateParams params);

  Future<void> delete(String id);
}


class PaginateParams {
  final int limit;
  final int offset;
  final String? orderBy;
  final bool ascending;
  final String? filterBy;
  final String? filterValue;

  PaginateParams({
    this.limit = 10,
    this.offset = 0,
    this.orderBy,
    this.ascending = true,
    this.filterBy,
    this.filterValue,
  });
}