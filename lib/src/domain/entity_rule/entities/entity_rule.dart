import 'package:metamorphis/src/domain/entity_rule_group_condition/entities/entity_rule_group_condition.dart';
import 'package:uuid/uuid.dart';

class EntityRule {
  late final String id;
  String errorMessage;
  final String entityId;
  late final List<EntityRuleGroupCondition> groupConditions;

  EntityRule({
    String? id,
    required this.errorMessage,
    required this.entityId,
    List<EntityRuleGroupCondition>? groupConditions,
  }) {
    {
      this.id = id ?? const Uuid().v4();
      this.groupConditions = groupConditions ?? [];
    }
  }
}
