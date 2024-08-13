import 'package:metamorphis/src/domain/value_object_group_condition/entities/value_object_group_condition.dart';
import 'package:metamorphis/src/domain/value_object_rule/entities/value_object_rule.dart';
import 'package:metamorphis/src/infrastructure/data/value_object_group_condition/models/value_object_group_condition_model.dart';

class ValueObjectRuleModel extends ValueObjectRule {
  ValueObjectRuleModel({
    required super.id,
    required super.errorMessage,
    required super.valueObjectId,
    super.groupConditions,
  });

  factory ValueObjectRuleModel.fromValueObjectRule(
    ValueObjectRule valueObjectRule,
  ) {
    return ValueObjectRuleModel(
      id: valueObjectRule.id,
      errorMessage: valueObjectRule.errorMessage,
      valueObjectId: valueObjectRule.valueObjectId,
      groupConditions: valueObjectRule.groupConditions,
    );
  }

  factory ValueObjectRuleModel.fromMap(Map<String, dynamic> json) {
    final List<ValueObjectGroupCondition> groupConditions = [];
    if (json['groupConditions'] != null) {
      final conditions = json['groupConditions'] as List;
      groupConditions.addAll(
        conditions.map((condition) {
          return ValueObjectGroupConditionModel.fromMap(condition);
        }).toList(),
      );
    }
    return ValueObjectRuleModel(
      id: json['id'],
      errorMessage: json['errorMessage'],
      valueObjectId: json['valueObjectId'],
      groupConditions: groupConditions,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'errorMessage': errorMessage,
      'valueObjectId': valueObjectId,
      'groupConditions': groupConditions.map((groupCondition) {
        final model = ValueObjectGroupConditionModel.fromEntity(groupCondition);
        return model.toMap();
      }).toList(),
    };
  }
}
