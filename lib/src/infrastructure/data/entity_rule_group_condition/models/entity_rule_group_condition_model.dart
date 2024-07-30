import 'package:metamorphis/src/domain/entity_rule_group_condition/entities/entity_rule_group_condition.dart';

class EntityRuleGroupConditionModel extends EntityRuleGroupCondition {
  EntityRuleGroupConditionModel({
    required super.id,
    super.logicOperator,
    super.entityRuleId,
    super.entityRuleGroupCondition,
  });

  factory EntityRuleGroupConditionModel.fromEntity(
    EntityRuleGroupCondition application,
  ) {
    return EntityRuleGroupConditionModel(
      id: application.id,
      logicOperator: application.logicOperator,
      entityRuleId: application.entityRuleId,
      entityRuleGroupCondition: application.entityRuleGroupCondition,
    );
  }

  factory EntityRuleGroupConditionModel.fromMap(Map<String, dynamic> json) {
    return EntityRuleGroupConditionModel(
      id: json['id'],
      logicOperator: json['logicOperator'],
      entityRuleId: json['entityRuleId'],
      entityRuleGroupCondition: json['entityRuleGroupCondition'],
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
    };
  }
}
