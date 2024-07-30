import 'package:uuid/uuid.dart';

class ValueObjectRuleCondition {
  late final String id;
  String? logicOperator;
  String? targetValue;
  String? comparatorOperator;
  String? regex;
  final String valueObjectGroupConditionId;

  ValueObjectRuleCondition({
    String? id,
    this.logicOperator,
    this.targetValue,
    this.comparatorOperator,
    this.regex,
    required this.valueObjectGroupConditionId,
  }) {
    {
      this.id = id ?? const Uuid().v4();
    }
  }
}
