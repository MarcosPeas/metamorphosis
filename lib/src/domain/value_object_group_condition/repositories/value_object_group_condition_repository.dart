import 'package:metamorphis/src/domain/value_object_group_condition/entities/value_object_group_condition.dart';

abstract class ValueObjectGroupConditionRepository {
  Future<ValueObjectGroupCondition> save(ValueObjectGroupCondition application);

  Future<ValueObjectGroupCondition> update(
    ValueObjectGroupCondition application,
  );

  Future<ValueObjectGroupCondition> getById(String id);

  Future<List<ValueObjectGroupCondition>> getByValueObjectRule(
    String valueObjectRuleId,
  );

  Future<void> delete(String id);
}
