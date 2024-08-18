import 'package:metamorphis/src/domain/value_object_group_condition/entities/value_object_group_condition.dart';
import 'package:metamorphis/src/infrastructure/data/value_object_rule_condition/models/value_object_rule_condition_model.dart';

class ValueObjectGroupConditionModel extends ValueObjectGroupCondition {
  ValueObjectGroupConditionModel({
    required super.id,
    required super.logicOperator,
    super.groupConditions,
    super.conditions,
    required super.valueObjectRuleId,
  });

  factory ValueObjectGroupConditionModel.fromEntity(
      ValueObjectGroupCondition application) {
    return ValueObjectGroupConditionModel(
      id: application.id,
      logicOperator: application.logicOperator,
      groupConditions: application.groupConditions,
      valueObjectRuleId: application.valueObjectRuleId,
      conditions: application.conditions,
    );
  }

  factory ValueObjectGroupConditionModel.fromMap(Map<String, dynamic> json) {
    return ValueObjectGroupConditionModel(
      id: json['id'],
      logicOperator: json['logicOperator'],
      valueObjectRuleId: json['valueObjectRuleId'],
      groupConditions: json['groupConditions'] != null
          ? (json['groupConditions'] as List)
              .map((item) => ValueObjectGroupConditionModel.fromMap(item))
              .toList()
          : [],
      conditions: json['conditions'] != null
          ? (json['conditions'] as List)
              .map((item) => ValueObjectRuleConditionModel.fromMap(item))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'logicOperator': logicOperator,
      'valueObjectRuleId': valueObjectRuleId,
      'groupConditions': groupConditions.map((item) {
        return ValueObjectGroupConditionModel.fromEntity(item).toMap();
      }),
      'conditions': conditions.map((item) {
        return ValueObjectRuleConditionModel.fromEntity(item).toMap();
      }),
    };
  }
}
