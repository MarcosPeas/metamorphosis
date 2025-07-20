import 'package:metamorphis/src/domain/enumerator/entities/enumerator.dart';

abstract class EnumeratorRepository {
  Future<Enumerator> save(Enumerator enumerator);

  Future<Enumerator> update(Enumerator enumerator);

  Future<Enumerator> getById(String id);

  Future<List<Enumerator>> getByEntity(String entityId);

  Future<void> delete(String id);
}
