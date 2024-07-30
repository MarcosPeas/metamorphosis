import 'package:metamorphis/src/domain/value_object_group_condition/entities/value_object_group_condition.dart';

class ValueObjectGroupConditionModel extends ValueObjectGroupCondition {
  ValueObjectGroupConditionModel({
    required super.id,
    required super.logicOperator,
    super.valueObjectGroupCondition,
    required super.valueObjectRuleId,
  });

  factory ValueObjectGroupConditionModel.fromEntity(
      ValueObjectGroupCondition application) {
    return ValueObjectGroupConditionModel(
      id: application.id,
      logicOperator: application.logicOperator,
      valueObjectGroupCondition: application.valueObjectGroupCondition,
      valueObjectRuleId: application.valueObjectRuleId,
    );
  }

  factory ValueObjectGroupConditionModel.fromMap(Map<String, dynamic> json) {
    return ValueObjectGroupConditionModel(
      id: json['id'],
      logicOperator: json['logicOperator'],
      valueObjectRuleId: json['valueObjectRuleId'],
      valueObjectGroupCondition: json['valueObjectGroupCondition'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': super.id,
      'logicOperator': super.logicOperator,
      'valueObjectRuleId': super.valueObjectRuleId,
      'valueObjectGroupCondition': super.valueObjectGroupCondition.map((item) {
        return ValueObjectGroupConditionModel.fromEntity(item).toJson();
      }),
    };
  }
}
