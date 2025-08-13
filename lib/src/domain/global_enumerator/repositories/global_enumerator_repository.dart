import 'package:metamorphis/src/domain/_core/domain/repository.dart';
import 'package:metamorphis/src/domain/global_enumerator/entities/global_enumerator.dart';

class GlobalEnumeratorRepository extends Repository<GlobalEnumerator> {
  @override
  Future<void> delete(GlobalEnumerator enumerator) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<List<GlobalEnumerator>> filter(PaginateParams params) {
    // TODO: implement filter
    throw UnimplementedError();
  }

  @override
  Future<GlobalEnumerator> getById(String id) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<Page<GlobalEnumerator>> paginate(Filter filter) {
    // TODO: implement paginate
    throw UnimplementedError();
  }

  @override
  Future<GlobalEnumerator> save(GlobalEnumerator enumerator) {
    // TODO: implement save
    throw UnimplementedError();
  }

  @override
  Future<GlobalEnumerator> update(GlobalEnumerator enumerator) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
