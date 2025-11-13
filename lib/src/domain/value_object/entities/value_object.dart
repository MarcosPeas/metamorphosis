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
  late bool _usedInSchemeGeneration;
  late SchemeStatus _status;
  ValueObject? child;
  final int idAutoincrementStartAt;

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
    bool usedInSchemeGeneration = false,
    SchemeStatus? status,
    this.child,
    this.idAutoincrementStartAt = 1,
  }) {
    this.id = id ?? const Uuid().v4();
    this.rules = rules ?? [];
    _enumName = enumName;
    _usedInSchemeGeneration = usedInSchemeGeneration;
    _status = status ?? SchemeStatus.created;
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

  bool get isId => type.toUpperCase().startsWith('ID');

  bool get isUUID => type == 'ID - String(UUID)';

  bool get isLongId => type == 'ID - long(AUTO INCREMENT)';

  bool get isValueObject {
    return !isEnum &&
        !isBoolean &&
        name != 'createdAt' &&
        name != 'updatedAt' &&
        !isId;
  }

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

  bool get isDate => type == 'Date';

  bool get isDateTime => type == 'DateTime';

  bool get isTime => type == 'Time';

  bool get isAnyDate => isDate || isDateTime || isTime;

  bool get isString => type == 'String';

  bool get isByte => type == 'byte/int8';

  bool get isShort => type == 'short/int16';

  bool get isInt => type == 'int/int32';

  bool get isLong => type == 'long/int64';

  bool get isFloat => type == 'float/float32';

  bool get isDouble => type == 'double/float64';

  bool get isBigDecimal => type == 'BigDecimal';

  bool get isBoolean => type == 'bool';

  bool get isNumber {
    return isByte ||
        isShort ||
        isInt ||
        isLong ||
        isFloat ||
        isDouble ||
        isBigDecimal;
  }

  bool get isAllInt {
    return isByte || isShort || isInt || isLong;
  }

  bool get isAllDecimal {
    return isFloat || isDouble || isBigDecimal;
  }

  get usedInSchemeGeneration => _usedInSchemeGeneration;

  void removeEnumValue(String value) {
    final valuesList = _enumValues.split(',');
    valuesList.remove(value.toConstantCase());
    _enumValues = valuesList.join(',');
  }

  bool isSimilar(ValueObject other) {
    if (name != other.name) {
      return false;
    }
    if (type != other.type) {
      return false;
    }
    if (isNullable != other.isNullable) {
      return false;
    }
    if (isUnique != other.isUnique) {
      return false;
    }
    if (_enumName != other._enumName) {
      return false;
    }
    return true;
  }

  SchemeStatus get status => _status;

  void changeStatus(SchemeStatus status) {
    _status = status;
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
    int? idAutoincrementStartAt,
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
      usedInSchemeGeneration: _usedInSchemeGeneration,
      child: child,
      idAutoincrementStartAt:
          idAutoincrementStartAt ?? this.idAutoincrementStartAt,
    );
  }

  void changeToUsedInSchemeGeneration() {
    if (child != null) {
      child!.changeToUsedInSchemeGeneration();
      return;
    }
    if (_usedInSchemeGeneration) {
      return;
    }
    _usedInSchemeGeneration = true;
  }
}
