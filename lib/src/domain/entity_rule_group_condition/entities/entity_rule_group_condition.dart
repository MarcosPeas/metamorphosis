import 'package:uuid/uuid.dart';

class EntityRuleGroupCondition {
  late final String id;
  String? logicOperator;
  String? entityRuleId;
  EntityRuleGroupCondition? entityRuleGroupCondition;

  EntityRuleGroupCondition({
    String? id,
    this.logicOperator,
    this.entityRuleId,
    this.entityRuleGroupCondition,
  }) {
    {
      this.id = id ?? const Uuid().v4();
    }
  }
}
