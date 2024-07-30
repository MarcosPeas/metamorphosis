import 'package:metamorphis/src/domain/entity_rule/entities/entity_rule.dart';

abstract class EntityRuleRepository {
  Future<EntityRule> save(EntityRule application);

  Future<EntityRule> update(EntityRule application);

  Future<EntityRule> getById(String id);

  Future<List<EntityRule>> getByEntity(String entityId);

  Future<void> delete(String id);
}
