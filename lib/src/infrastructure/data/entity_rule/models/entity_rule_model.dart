import 'dart:convert';

import 'package:metamorphis/src/domain/entity_rule/entities/entity_rule.dart';
import 'package:metamorphis/src/domain/entity_rule_group_condition/entities/entity_rule_group_condition.dart';
import 'package:metamorphis/src/infrastructure/data/entity_rule_group_condition/models/entity_rule_group_condition_model.dart';

class EntityRuleModel extends EntityRule {
  EntityRuleModel({
    required super.id,
    required super.errorMessage,
    required super.entityId,
    required super.groupConditions,
  });

  factory EntityRuleModel.fromEntity(EntityRule application) {
    return EntityRuleModel(
      id: application.id,
      errorMessage: application.errorMessage,
      entityId: application.entityId,
      groupConditions: application.groupConditions,
    );
  }

  factory EntityRuleModel.fromMap(Map<String, dynamic> map) {
    List<EntityRuleGroupCondition> groupConditions = [];
    if (map['groupConditions'] != null) {
      final groupConditionsJson = map['groupConditions'] as List;
      groupConditions.addAll(
        groupConditionsJson.map((groupCondition) {
          return EntityRuleGroupConditionModel.fromMap(groupCondition);
        }).toList(),
      );
    }
    return EntityRuleModel(
      id: map['id'],
      errorMessage: map['errorMessage'],
      entityId: map['entityId'],
      groupConditions: groupConditions,
    );
  }

  factory EntityRuleModel.fromJson(String json) {
    return EntityRuleModel.fromMap(jsonDecode(json));
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'errorMessage': errorMessage,
      'entityId': entityId,
      'groupConditions': groupConditions.map((groupCondition) {
        return EntityRuleGroupConditionModel.fromEntity(groupCondition).toMap();
      }).toList(),
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }
}
