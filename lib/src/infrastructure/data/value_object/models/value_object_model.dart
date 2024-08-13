import 'package:metamorphis/src/domain/value_object/entities/value_object.dart';
import 'package:metamorphis/src/domain/value_object_rule/entities/value_object_rule.dart';
import 'package:metamorphis/src/infrastructure/data/value_object_rule/models/value_object_rule_model.dart';

class ValueObjectModel extends ValueObject {
  ValueObjectModel({
    required super.id,
    required super.name,
    required super.type,
    required super.nullable,
    required super.entityId,
    super.rules,
  });

  factory ValueObjectModel.fromValueObject(ValueObject valueObject) {
    return ValueObjectModel(
      id: valueObject.id,
      name: valueObject.name,
      type: valueObject.type,
      nullable: valueObject.nullable,
      entityId: valueObject.entityId,
      rules: valueObject.rules,
    );
  }

  factory ValueObjectModel.fromMap(Map<String, dynamic> json) {
    final List<ValueObjectRule> rulesModel = [];
    if (json['rules'] != null) {
      final rules = json['rules'] as List;
      rulesModel.addAll(
        rules.map((rule) => ValueObjectRuleModel.fromMap(rule)).toList(),
      );
    }
    return ValueObjectModel(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      nullable: json['nullable'],
      entityId: json['entityId'],
      rules: rulesModel,
    );
  }

  Map<String, dynamic> toMap() {
    final rulesJson = List.generate(rules.length, (index) {
      final ruleModel = ValueObjectRuleModel.fromValueObjectRule(
        rules[index],
      );
      return ruleModel.toMap();
    });
    return {
      'id': id,
      'name': name,
      'type': type,
      'nullable': nullable,
      'entityId': entityId,
      'rules': rulesJson,
    };
  }
}
