import 'package:metamorphis/src/domain/value_object/entities/value_object.dart';
import 'package:metamorphis/src/domain/value_object_rule_condition/entities/value_object_rule_condition.dart';

class ValueObjectRuleConditionViewModel extends ValueObjectRuleCondition {

  final ValueObject valueObject;

  ValueObjectRuleConditionViewModel({
    required super.id,
    required super.valueObjectGroupConditionId,
    required super.comparatorOperator,
    required super.logicOperator,
    required super.targetValue,
    required this.valueObject,
  });

  factory ValueObjectRuleConditionViewModel.fromEntity(
    ValueObjectRuleCondition entity,
    ValueObject valueObject,
  ) {
    return ValueObjectRuleConditionViewModel(
      id: entity.id,
      valueObjectGroupConditionId: entity.valueObjectGroupConditionId,
      comparatorOperator: entity.comparatorOperator,
      logicOperator: entity.logicOperator,
      targetValue: entity.targetValue,
      valueObject: valueObject,
    );
  }

  String? getTargetValue() {
    if (valueObject.isAnyDate) {
      final date = DateTime.tryParse(targetValue ?? '');
      if (date != null) {
        return date.toLocal().toIso8601String();
      }
    }
    return targetValue;
  }
}
