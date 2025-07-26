import 'package:metamorphis/src/domain/_core/domain/repository.dart';
import 'package:metamorphis/src/domain/data_class/entities/data_class.dart';

class DataClassRepository implements Repository<DataClass> {
  @override
  Future<void> delete(String id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<DataClass> getById(String id) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<DataClass> save(DataClass entity) {
    // TODO: implement save
    throw UnimplementedError();
  }

  @override
  Future<DataClass> update(DataClass entity) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<List<DataClass>> filter(PaginateParams params) {
    // TODO: implement filter
    throw UnimplementedError();
  }

  @override
  Future<Page<DataClass>> paginate(Filter filter) {
    // TODO: implement paginate
    throw UnimplementedError();
  }
}
