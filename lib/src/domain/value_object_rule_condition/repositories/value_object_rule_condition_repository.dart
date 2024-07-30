import 'package:metamorphis/src/domain/value_object_rule_condition/entities/value_object_rule_condition.dart';

abstract class ValueObjectRuleConditionRepository {
  Future<ValueObjectRuleCondition> save(
    ValueObjectRuleCondition valueObjectRuleCondition,
  );

  Future<ValueObjectRuleCondition> update(
    ValueObjectRuleCondition valueObjectRuleCondition,
  );

  Future<ValueObjectRuleCondition> getById(String id);

  Future<List<ValueObjectRuleCondition>> getByValueObjectGroupCondition(
    String projectId,
  );

  Future<void> delete(String id);
}
