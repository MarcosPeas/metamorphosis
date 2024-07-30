import 'package:metamorphis/src/domain/entity_rule_group_condition/entities/entity_rule_group_condition.dart';

abstract class EntityRuleGroupConditionRepository {
  Future<EntityRuleGroupCondition> save(
    EntityRuleGroupCondition entityRuleGroupCondition,
  );

  Future<EntityRuleGroupCondition> update(
    EntityRuleGroupCondition entityRuleGroupCondition,
  );

  Future<EntityRuleGroupCondition> getById(String id);

  Future<List<EntityRuleGroupCondition>> getByEntityRule(String entityRuleId);

  Future<void> delete(String id);
}
