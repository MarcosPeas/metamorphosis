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
  Future<List<DataClass>> paginate(PaginateParams params) {
    // TODO: implement paginate
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

}