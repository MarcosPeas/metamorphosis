import 'package:metamorphis/src/domain/value_object_rule_condition/entities/value_object_rule_condition.dart';

class ValueObjectRuleConditionModel extends ValueObjectRuleCondition {
  ValueObjectRuleConditionModel({
    required super.id,
    super.logicOperator,
    super.targetValue,
    super.comparatorOperator,
    super.regex,
    required super.valueObjectGroupConditionId,
  });

  factory ValueObjectRuleConditionModel.fromEntity(ValueObjectRuleCondition application) {
    return ValueObjectRuleConditionModel(
      id: application.id,
      logicOperator: application.logicOperator,
      targetValue: application.targetValue,
      comparatorOperator: application.comparatorOperator,
      regex: application.regex,
      valueObjectGroupConditionId: application.valueObjectGroupConditionId,
    );
  }

  factory ValueObjectRuleConditionModel.fromMap(Map<String, dynamic> json) {
    return ValueObjectRuleConditionModel(
      id: json['id'],
      logicOperator: json['logicOperator'],
      targetValue: json['targetValue'],
      comparatorOperator: json['comparatorOperator'],
      regex: json['regex'],
      valueObjectGroupConditionId: json['valueObjectGroupConditionId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': super.id,
      'logicOperator': super.logicOperator,
      'targetValue': super.targetValue,
      'comparatorOperator': super.comparatorOperator,
      'regex': super.regex,
      'valueObjectGroupConditionId': super.valueObjectGroupConditionId,
    };
  }
}
