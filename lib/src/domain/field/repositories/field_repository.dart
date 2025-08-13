import 'package:metamorphis/src/domain/_core/domain/repository.dart';
import 'package:metamorphis/src/domain/field/entities/field.dart';

class FieldRepository implements Repository<Field> {
  @override
  Future<void> delete(Field field) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Field> getById(String id) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<Field> save(Field entity) {
    // TODO: implement save
    throw UnimplementedError();
  }

  @override
  Future<Field> update(Field entity) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<List<Field>> filter(PaginateParams params) {
    // TODO: implement filter
    throw UnimplementedError();
  }

  @override
  Future<Page<Field>> paginate(Filter filter) {
    // TODO: implement paginate
    throw UnimplementedError();
  }
}
