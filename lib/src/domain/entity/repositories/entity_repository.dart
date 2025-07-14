import 'package:metamorphis/src/domain/entity/entities/entity.dart';

abstract class EntityRepository {
  Future<Entity> save(Entity entity);

  Future<Entity> update(Entity entity);

  Future<Entity> getById(String id);

  Future<List<Entity>> getByApplication(String applicationId);

  Future<void> delete(String id);
}
