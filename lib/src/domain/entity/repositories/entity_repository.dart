import 'package:metamorphis/src/domain/entity/entities/entity.dart';

abstract class EntityRepository {
  Future<Entity> save(Entity entity);

  Future<Entity> update(Entity entity);

  Future<Entity> getById(String id);

  Future<List<Entity>> getByBoundedContext(String boundedContextId);

  Future<void> delete(String id);
}
