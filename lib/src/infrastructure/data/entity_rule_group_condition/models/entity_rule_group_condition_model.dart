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

  factory EntityRuleGroupConditionModel.fromMap(Map<String, dynamic> json) {
    return EntityRuleGroupConditionModel(
      id: json['id'],
      logicOperator: json['logicOperator'],
      entityRuleId: json['entityRuleId'],
      entityRuleGroupCondition: json['entityRuleGroupCondition'] != null
          ? EntityRuleGroupConditionModel.fromMap(
              json['entityRuleGroupCondition'],
            )
          : null,
      conditions: json['conditions'].map<EntityRuleCondition>((condition) {
        return EntityRuleConditionModel.fromMap(condition);
      }).toList(),
    );
  }

  Map<String, dynamic> toJson() {
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
      'entityRuleGroupCondition': model?.toJson(),
      'conditions': conditions.map((condition) {
        return EntityRuleConditionModel.fromEntity(condition).toJson();
      }).toList(),
    };
  }
}
