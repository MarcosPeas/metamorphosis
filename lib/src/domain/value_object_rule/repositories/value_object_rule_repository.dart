import 'package:metamorphis/src/domain/value_object_rule/entities/value_object_rule.dart';

abstract class ValueObjectRuleRepository {
  Future<ValueObjectRule> save(ValueObjectRule valueObjectRule);

  Future<ValueObjectRule> update(ValueObjectRule valueObjectRule);

  Future<ValueObjectRule> getById(String id);

  Future<List<ValueObjectRule>> getByValueObject(String valueObjectId);

  Future<void> delete(String id);
}
