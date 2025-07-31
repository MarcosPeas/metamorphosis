import 'dart:convert';

import 'package:metamorphis/src/domain/entity_rule_condition/entity_rule_condition.dart';
import 'package:metamorphis/src/domain/entity_rule_group_condition/entities/entity_rule_group_condition.dart';
import 'package:metamorphis/src/infrastructure/data/entity_rule_condition/models/entity_rule_condition_model.dart';

class EntityRuleGroupConditionModel extends EntityRuleGroupCondition {
  EntityRuleGroupConditionModel({
    required super.id,
    required super.logicOperator,
    required super.entityRuleId,
    required super.entityRuleGroupCondition,
    required super.conditions,
  });

  factory EntityRuleGroupConditionModel.fromEntity(
    EntityRuleGroupCondition application,
  ) {
    return EntityRuleGroupConditionModel(
      id: application.id,
      logicOperator: application.logicOperator,
      entityRuleId: application.entityRuleId,
      entityRuleGroupCondition: application.entityRuleGroupCondition,
      conditions: application.conditions,
    );
  }

  factory EntityRuleGroupConditionModel.fromMap(Map<String, dynamic> map) {
    return EntityRuleGroupConditionModel(
      id: map['id'],
      logicOperator: map['logicOperator'],
      entityRuleId: map['entityRuleId'],
      entityRuleGroupCondition: map['entityRuleGroupCondition'] != null
          ? EntityRuleGroupConditionModel.fromMap(
              map['entityRuleGroupCondition'],
            )
          : null,
      conditions: map['conditions'].map<EntityRuleCondition>((condition) {
        return EntityRuleConditionModel.fromMap(condition);
      }).toList(),
    );
  }

  factory EntityRuleGroupConditionModel.fromJson(String json) {
    return EntityRuleGroupConditionModel.fromMap(jsonDecode(json));
  }

  Map<String, dynamic> toMap() {
    EntityRuleGroupConditionModel? model;
    if (entityRuleGroupCondition != null) {
      model = EntityRuleGroupConditionModel.fromEntity(
        entityRuleGroupCondition!,
      );
    }
    return {
      'id': id,
      'logicOperator': logicOperator,
      'entityRuleId': entityRuleId,
      'entityRuleGroupCondition': model?.toMap(),
      'conditions': conditions.map((condition) {
        return EntityRuleConditionModel.fromEntity(condition).toMap();
      }).toList(),
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }
}
