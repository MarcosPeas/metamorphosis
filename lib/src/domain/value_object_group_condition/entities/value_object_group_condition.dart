import 'package:uuid/uuid.dart';

class ValueObjectGroupCondition {
  late final String id;
  String logicOperator;
  final String valueObjectRuleId;
  final List<ValueObjectGroupCondition> valueObjectGroupCondition = [];

  ValueObjectGroupCondition({
    String? id,
    required this.logicOperator,
    required this.valueObjectRuleId,
    List<ValueObjectGroupCondition>? valueObjectGroupCondition,
  }) {
    {
      this.id = id ?? const Uuid().v4();
      this.valueObjectGroupCondition.addAll(valueObjectGroupCondition ?? []);
    }
  }
}
