import 'package:metamorphis/src/domain/_core/domain/repository.dart';
import 'package:metamorphis/src/domain/field/entities/field.dart';

class FieldRepository implements Repository<Field> {
  @override
  Future<void> delete(String id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Field> getById(String id) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<List<Field>> paginate(PaginateParams params) {
    // TODO: implement paginate
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
}
