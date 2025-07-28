import 'package:change_case/change_case.dart';
import 'package:metamorphis/src/domain/entity/entities/entity.dart';
import 'package:metamorphis/src/domain/value_object_rule/entities/value_object_rule.dart';
import 'package:uuid/uuid.dart';

class ValueObject {
  late final String id;
  String name;
  String type;
  bool isNullable;
  bool isUnique;
  late final List<ValueObjectRule> rules;
  late String _enumName;
  late String _enumValues;
  final String entityId;

  ValueObject({
    String? id,
    required this.name,
    required this.type,
    required this.isNullable,
    required this.isUnique,
    List<ValueObjectRule>? rules,
    required String enumName,
    required String enumValues,
    required this.entityId,
  }) {
    this.id = id ?? const Uuid().v4();
    this.rules = rules ?? [];
    _enumName = enumName;
    _addEnumValues(enumValues);
  }

  factory ValueObject.ofEntity(Entity entity) {
    return ValueObject(
      name: '',
      type: 'String',
      isNullable: false,
      isUnique: false,
      rules: [],
      enumName: '',
      enumValues: '',
      entityId: entity.id,
    );
  }

  String get enumName => _enumName;

  String get enumValues => _enumValues;

  bool get isEnum => type == 'Enum';

  void addRule(ValueObjectRule rule) {
    rules.add(rule);
  }

  void removeRule(ValueObjectRule rule) {
    rules.remove(rule);
  }

  bool ignoreRules() {
    if (rules.isEmpty) {
      return true;
    }
    final mRules = [...rules];
    mRules.removeWhere((r) => r.groupConditions.isEmpty);
    if (mRules.isEmpty) {
      return true;
    }
    return false;
  }

  void updateRule(ValueObjectRule rule) {
    final index = rules.indexWhere((r) => r.id == rule.id);
    if (index != -1) {
      rules[index] = rule;
    }
  }

  void _addEnumValues(String values) {
    String result = values.trim();
    while (result.contains('  ')) {
      result = result.replaceAll('  ', ' ');
    }
    while (result.contains(',,')) {
      result = result.replaceAll(',,', ',');
    }
    if (result.endsWith(',')) {
      result = result.substring(0, result.length - 1);
    }
    if (result.startsWith(',')) {
      result = result.substring(1);
    }
    _enumValues = result;
  }

  bool get requirementsAreCompleted {
    if (name.isEmpty) {
      return false;
    }
    if (type == 'Enum' && (_enumName.isEmpty || _enumValues.isEmpty)) {
      return false;
    }
    return true;
  }

  bool get isDate {
    return type == 'Date';
  }

  bool get isDateTime {
    return type == 'DateTime';
  }

  bool get isTime {
    return type == 'Time';
  }

  void removeEnumValue(String value) {
    final valuesList = _enumValues.split(',');
    valuesList.remove(value.toConstantCase());
    _enumValues = valuesList.join(',');
  }

  ValueObject copyWith({
    String? id,
    String? name,
    String? type,
    bool? isNullable,
    bool? isUnique,
    List<ValueObjectRule>? rules,
    String? enumName,
    String? enumValues,
  }) {
    return ValueObject(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      isNullable: isNullable ?? this.isNullable,
      isUnique: isUnique ?? this.isUnique,
      rules: rules ?? this.rules,
      enumName: enumName ?? this.enumName,
      enumValues: enumValues ?? this.enumValues,
      entityId: entityId,
    );
  }
}
