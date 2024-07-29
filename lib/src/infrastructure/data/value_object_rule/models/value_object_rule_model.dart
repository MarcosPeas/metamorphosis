import 'package:metamorphis/src/domain/value_object_rule/entities/value_object_rule.dart';

class ValueObjectRuleModel extends ValueObjectRule {
  ValueObjectRuleModel({
    required super.id,
    required super.errorMessage,
    required super.valueObjectId,
  });

  factory ValueObjectRuleModel.fromValueObjectRule(
    ValueObjectRule valueObjectRule,
  ) {
    return ValueObjectRuleModel(
      id: valueObjectRule.id,
      errorMessage: valueObjectRule.errorMessage,
      valueObjectId: valueObjectRule.valueObjectId,
    );
  }

  factory ValueObjectRuleModel.fromMap(Map<String, dynamic> json) {
    return ValueObjectRuleModel(
      id: json['id'],
      errorMessage: json['errorMessage'],
      valueObjectId: json['valueObjectId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'errorMessage': errorMessage,
      'valueObjectId': valueObjectId,
    };
  }
}
