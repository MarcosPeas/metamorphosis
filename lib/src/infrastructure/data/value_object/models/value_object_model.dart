import 'dart:convert';

import 'package:metamorphis/src/domain/value_object/entities/value_object.dart';
import 'package:metamorphis/src/domain/value_object_rule/entities/value_object_rule.dart';
import 'package:metamorphis/src/infrastructure/data/value_object_rule/models/value_object_rule_model.dart';

class ValueObjectModel extends ValueObject {
  ValueObjectModel({
    required super.id,
    required super.name,
    required super.type,
    required super.isNullable,
    required super.isUnique,
    required super.enumName,
    required super.enumValues,
    super.rules,
    required super.entityId,
  });

  factory ValueObjectModel.fromValueObject(ValueObject valueObject) {
    return ValueObjectModel(
      id: valueObject.id,
      name: valueObject.name,
      type: valueObject.type,
      isNullable: valueObject.isNullable,
      isUnique: valueObject.isUnique,
      enumName: valueObject.enumName,
      enumValues: valueObject.enumValues,
      rules: valueObject.rules,
      entityId: valueObject.entityId,
    );
  }

  factory ValueObjectModel.fromMap(Map<String, dynamic> map) {
    final List<ValueObjectRule> rulesModel = [];
    if (map['rules'] != null) {
      final rules = map['rules'] as List;
      rulesModel.addAll(
        rules.map((rule) => ValueObjectRuleModel.fromMap(rule)).toList(),
      );
    }
    return ValueObjectModel(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      isNullable: map['isNullable'] ?? false,
      entityId: map['entityId'],
      isUnique: map['isUnique'] ?? false,
      rules: rulesModel,
      enumName: map['enumName'] ?? '',
      enumValues: map['enumValues'] ?? '',
    );
  }

  factory ValueObjectModel.fromJson(String json) {
    return ValueObjectModel.fromMap(jsonDecode(json));
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
      'isNullable': isNullable,
      'entityId': entityId,
      'isUnique': isUnique,
      'rules': rulesJson,
      'enumName': enumName,
      'enumValues': enumValues,
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }
}
