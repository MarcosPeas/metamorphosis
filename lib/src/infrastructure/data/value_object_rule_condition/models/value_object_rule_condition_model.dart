import 'dart:convert';

import 'package:metamorphis/src/domain/value_object_rule_condition/entities/value_object_rule_condition.dart';

class ValueObjectRuleConditionModel extends ValueObjectRuleCondition {
  ValueObjectRuleConditionModel({
    required super.id,
    super.logicOperator,
    super.targetValue,
    super.comparatorOperator,
    required super.valueObjectGroupConditionId,
  });

  factory ValueObjectRuleConditionModel.fromEntity(ValueObjectRuleCondition application) {
    return ValueObjectRuleConditionModel(
      id: application.id,
      logicOperator: application.logicOperator,
      targetValue: application.targetValue,
      comparatorOperator: application.comparatorOperator,
      valueObjectGroupConditionId: application.valueObjectGroupConditionId,
    );
  }

  factory ValueObjectRuleConditionModel.fromMap(Map<String, dynamic> map) {
    return ValueObjectRuleConditionModel(
      id: map['id'],
      logicOperator: map['logicOperator'],
      targetValue: map['targetValue'] ?? map['regex'],
      comparatorOperator: map['comparatorOperator'],
      valueObjectGroupConditionId: map['valueObjectGroupConditionId'],
    );
  }

  factory ValueObjectRuleConditionModel.fromJson(String json) {
    return ValueObjectRuleConditionModel.fromMap(jsonDecode(json));
  }

  Map<String, dynamic> toMap() {
    return {
      'id': super.id,
      'logicOperator': super.logicOperator,
      'targetValue': super.targetValue,
      'comparatorOperator': super.comparatorOperator,
      'valueObjectGroupConditionId': super.valueObjectGroupConditionId,
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }
}
