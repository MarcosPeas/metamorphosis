import 'dart:convert';

import 'package:metamorphis/src/domain/value_object_group_condition/entities/value_object_group_condition.dart';
import 'package:metamorphis/src/domain/value_object_rule_condition/entities/value_object_rule_condition.dart';
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
    ValueObjectGroupCondition application,
  ) {
    return ValueObjectGroupConditionModel(
      id: application.id,
      logicOperator: application.logicOperator,
      groupConditions: application.groupConditions,
      valueObjectRuleId: application.valueObjectRuleId,
      conditions: application.conditions,
    );
  }

  factory ValueObjectGroupConditionModel.fromMap(Map<String, dynamic> map) {
    final conditions = <ValueObjectRuleCondition>[];
    final groupConditions = <ValueObjectGroupCondition>[];
    if (map['conditions'] != null) {
      final rules = map['conditions'] as List;
      conditions.addAll(
        rules.map((rule) {
          return ValueObjectRuleConditionModel.fromMap(rule);
        }).toList(),
      );
    }
    if (map['groupConditions'] != null) {
      final groupConditionsJson = map['groupConditions'] as List;
      groupConditions.addAll(
        groupConditionsJson.map((groupCondition) {
          return ValueObjectGroupConditionModel.fromMap(groupCondition);
        }).toList(),
      );
    }
    return ValueObjectGroupConditionModel(
      id: map['id'],
      logicOperator: map['logicOperator'],
      valueObjectRuleId: map['valueObjectRuleId'],
      groupConditions: groupConditions,
      conditions: conditions,
    );
  }

  factory ValueObjectGroupConditionModel.fromJson(String json) {
    return ValueObjectGroupConditionModel.fromMap(jsonDecode(json));
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

  String toJson() {
    return jsonEncode(toMap());
  }
}
