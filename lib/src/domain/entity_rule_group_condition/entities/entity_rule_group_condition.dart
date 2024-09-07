import 'package:metamorphis/src/domain/entity_rule_condition/entity_rule_condition.dart';
import 'package:uuid/uuid.dart';

class EntityRuleGroupCondition {
  late final String id;
  String? logicOperator;
  String? entityRuleId;
  EntityRuleGroupCondition? entityRuleGroupCondition;
  late final List<EntityRuleCondition> conditions;

  EntityRuleGroupCondition({
    String? id,
    this.logicOperator,
    this.entityRuleId,
    this.entityRuleGroupCondition,
    List<EntityRuleCondition>? conditions,
  }) {
    this.id = id ?? const Uuid().v4();
    this.conditions = conditions ?? [];
  }
}
