import 'dart:convert';

import 'package:metamorphis/src/domain/value_object/entities/value_object.dart';
import 'package:metamorphis/src/domain/value_object_rule/entities/value_object_rule.dart';
import 'package:metamorphis/src/infrastructure/data/value_object_rule/models/value_object_rule_model.dart';

class ValueObjectModel extends ValueObject {
  ValueObjectModel._({
    required super.id,
    required super.name,
    required super.type,
    required super.isNullable,
    required super.isUnique,
    required super.enumName,
    required super.enumValues,
    super.rules,
    required super.entityId,
    required super.usedInSchemeGeneration,
    required super.child,
    required super.idAutoincrementStartAt,
  });

  factory ValueObjectModel.fromEntity(ValueObject valueObject) {
    return ValueObjectModel._(
      id: valueObject.id,
      name: valueObject.name,
      type: valueObject.type,
      isNullable: valueObject.isNullable,
      isUnique: valueObject.isUnique,
      enumName: valueObject.enumName,
      enumValues: valueObject.enumValues,
      rules: valueObject.rules,
      entityId: valueObject.entityId,
      usedInSchemeGeneration: valueObject.usedInSchemeGeneration,
      child: valueObject.child,
      idAutoincrementStartAt: valueObject.idAutoincrementStartAt,
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
    ValueObject? child;
    if (map['child'] != null) {
      child = ValueObjectModel.fromMap(map['child']);
    }
    return ValueObjectModel._(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      isNullable: map['isNullable'] ?? false,
      entityId: map['entityId'],
      isUnique: map['isUnique'] ?? false,
      rules: rulesModel,
      enumName: map['enumName'] ?? '',
      enumValues: map['enumValues'] ?? '',
      usedInSchemeGeneration: map['used_in_scheme_generation'] ?? false,
      child: child,
      idAutoincrementStartAt: map['idAutoincrementStartAt'] ?? 1,
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
    ValueObjectModel? child;
    if (this.child != null) {
      child = ValueObjectModel.fromEntity(this.child!);
    }
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
      'used_in_scheme_generation': usedInSchemeGeneration,
      'child': child?.toMap(),
      'idAutoincrementStartAt': idAutoincrementStartAt,
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }
}
