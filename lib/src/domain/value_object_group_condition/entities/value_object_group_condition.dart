import 'package:metamorphis/src/domain/value_object_rule_condition/entities/value_object_rule_condition.dart';
import 'package:uuid/uuid.dart';

class ValueObjectGroupCondition {
  late final String id;
  String logicOperator;
  final String valueObjectRuleId;
  late final List<ValueObjectGroupCondition> groupConditions;
  late final List<ValueObjectRuleCondition> conditions;

  ValueObjectGroupCondition({
    String? id,
    required this.logicOperator,
    required this.valueObjectRuleId,
    List<ValueObjectGroupCondition>? groupConditions,
    List<ValueObjectRuleCondition>? conditions,
  }) {
    {
      this.id = id ?? const Uuid().v4();
      this.groupConditions = groupConditions ?? [];
      this.conditions = conditions ?? [];
    }
  }
}
