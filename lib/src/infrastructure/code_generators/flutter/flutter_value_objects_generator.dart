import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:change_case/change_case.dart';
import 'package:metamorphis/src/domain/entity/entities/entity.dart';
import 'package:metamorphis/src/domain/value_object/entities/value_object.dart';
import 'package:metamorphis/src/domain/value_object_rule_condition/entities/value_object_rule_condition.dart';

class FlutterValueObjectsGenerator {
  static final types = {
    'bool': 'bool',
    'byte/int8': 'int',
    'short/int16': 'int',
    'int/int32': 'int',
    'long/int64': 'int',
    'float/float32': 'double',
    'double/float64': 'double',
    'String': 'String',
    'Date': 'DateTime',
    'Time': 'DateTime',
    'DateTime': 'DateTime',
  };

  FlutterValueObjectsGenerator._();

  static List<ArchiveFile> generate({
    required Entity entity,
    required String entityPath,
  }) {
    final valueObjects = [...entity.valueObjects];
    valueObjects.removeWhere((vo) {
      return vo.ignoreRules();
    });
    List<ArchiveFile> files = [];
    for (final valueObject in valueObjects) {
      final result = _generateValueObject(
        valueObject: valueObject,
        entityPath: entityPath,
        entity: entity,
      );
      files.add(result);
    }
    return files;
  }

  static ArchiveFile _generateValueObject({
    required ValueObject valueObject,
    required String entityPath,
    required Entity entity,
  }) {
    final name = '${entity.name}_${valueObject.name}';
    final pascalName = ChangeCase(name).toPascalCase();
    final snackName = ChangeCase(name).toSnakeCase();

    String content = _valueObjectContent.replaceAll(
      '%name%',
      pascalName,
    );
    content = content.replaceAll(
      '%type%',
      types[valueObject.type]!,
    );

    final postRules = _ContentParams();
    final domainRules = _generateRules(
      valueObject: valueObject,
      postRules: postRules,
    );
    final imports = _generateImports(valueObject);

    content = content.replaceAll(
      '%domainRules%',
      '${postRules.content}$domainRules',
    );
    content = content.replaceAll(
      '%imports%',
      imports,
    );

    final bytes = utf8.encode(content);
    return ArchiveFile.noCompress(
      '$entityPath/value_objects/$snackName.dart',
      bytes.length,
      bytes,
    );
  }

  static String _generateImports(ValueObject valueObject) {
    final imports = <String>{};
    final rules = valueObject.rules;
    for (final rule in rules) {
      final groupConditions = rule.groupConditions;
      for (final groupCondition in groupConditions) {
        final conditions = groupCondition.conditions;
        for (final condition in conditions) {
          final comparator = condition.comparatorOperator;
          if (comparator == 'isCpf' || comparator == 'isCnpj') {
            imports.add('import \'package:brasil_fields/brasil_fields.dart\';');
          }
        }
      }
    }
    if (imports.isEmpty) {
      return '';
    }
    return '${imports.join('\n')}\n';
  }

  static String _generateRules({
    required ValueObject valueObject,
    required _ContentParams postRules,
  }) {
    String rulesContent = '';
    final rules = valueObject.rules;
    for (int r = 0; r < rules.length; r++) {
      final rule = rules[r];
      String groupContent = '    if ';
      final groupConditions = rule.groupConditions;
      if (groupConditions.length > 1) {
        groupContent += '(';
      }
      for (int i = 0; i < groupConditions.length; i++) {
        final groupCondition = groupConditions[i];
        groupContent += '(';
        if (i > 0) {
          final logicOperator = groupCondition.logicOperator;
          groupContent += logicOperator == 'AND' ? ' || ' : ' && ';
        }
        final conditions = groupCondition.conditions;
        for (int j = 0; j < conditions.length; j++) {
          final condition = conditions[j];
          if (j > 0) {
            final logicOperator = condition.logicOperator;
            groupContent += logicOperator == 'AND' ? ' || ' : ' && ';
          }
          groupContent += _generateCondition(
            valueObject: valueObject,
            condition: condition,
            postRules: postRules,
          );
        }
        groupContent += ')';
      }
      if (groupConditions.length > 1) {
        groupContent += ')';
      }
      groupContent += ' {\n';
      final errorMessage = rule.errorMessage;
      groupContent +=
          '      errors.add(\n        ConstraintError(\n          context: \'${valueObject.name}\',\n          message: \'$errorMessage\'\n        ),\n      );\n';
      groupContent += '    }';
      if (r < rules.length - 1) {
        groupContent += '\n';
      }
      rulesContent += groupContent;
    }
    return rulesContent;
  }

  static String _generateCondition({
    required ValueObject valueObject,
    required ValueObjectRuleCondition condition,
    required _ContentParams postRules,
  }) {
    final numbersType = [
      'byte/int8',
      'short/int16',
      'int/int32',
      'long/int64',
      'float/float32',
      'double/float64',
    ];
    String conditionContent = '';
    if (valueObject.type == 'String') {
      conditionContent = _generateConditionString(condition);
    } else if (numbersType.contains(valueObject.type)) {
      conditionContent = _generateConditionNumber(condition);
    } else if (valueObject.type == 'bool') {
      conditionContent = _generateConditionBoolean(condition);
    } else if (valueObject.type == 'DateTime') {
      conditionContent = _generateConditionDateTime(condition);
    } else if (valueObject.type == 'Date') {
      conditionContent = _generateConditionDate(
        condition: condition,
        postRules: postRules,
      );
    } else if (valueObject.type == 'Time') {
      conditionContent = _generateConditionTime(
        condition: condition,
        postRules: postRules,
      );
    }
    if (conditionContent.isEmpty) {
      conditionContent = 'false';
    }
    return conditionContent;
  }

  static String _generateConditionString(ValueObjectRuleCondition condition) {
    String conditionContent = '';
    if (condition.comparatorOperator == 'isEmpty') {
      conditionContent += 'value.isNotEmpty';
    } else if (condition.comparatorOperator == 'isNotEmpty') {
      conditionContent += 'value.isEmpty';
    } else if (condition.comparatorOperator == 'minLength') {
      conditionContent += 'value.length < ${condition.targetValue}';
    } else if (condition.comparatorOperator == 'maxLength') {
      conditionContent += 'value.length > ${condition.targetValue}';
    } else if (condition.comparatorOperator == 'equals') {
      conditionContent += 'value != ${condition.targetValue}';
    } else if (condition.comparatorOperator == 'notEquals') {
      conditionContent += 'value == ${condition.targetValue}';
    } else if (condition.comparatorOperator == 'lengthEquals') {
      conditionContent += 'value.length != ${condition.targetValue}';
    } else if (condition.comparatorOperator == 'isCpf') {
      conditionContent += '!UtilBrasilFields.isCPFValido(value)';
    } else if (condition.comparatorOperator == 'isCnpj') {
      conditionContent += '!UtilBrasilFields.isCNPJValido(value)';
    }
    return conditionContent;
  }

  static String _generateConditionNumber(ValueObjectRuleCondition condition) {
    String conditionContent = '';
    if (condition.comparatorOperator == 'isEqualTo') {
      conditionContent += 'value != ${condition.targetValue}';
    } else if (condition.comparatorOperator == 'isNotEqualTo') {
      conditionContent += 'value == ${condition.targetValue}';
    } else if (condition.comparatorOperator == 'isLessThan') {
      conditionContent += 'value.length >= ${condition.targetValue}';
    } else if (condition.comparatorOperator == 'isLessThanOrEqualTo') {
      conditionContent += 'value.length > ${condition.targetValue}';
    } else if (condition.comparatorOperator == 'isGreaterThan') {
      conditionContent += 'value <= ${condition.targetValue}';
    } else if (condition.comparatorOperator == 'isGreaterThanOrEqualTo') {
      conditionContent += 'value < ${condition.targetValue}';
    }
    return conditionContent;
  }

  static String _generateConditionDateTime(ValueObjectRuleCondition condition) {
    String conditionContent = '';
    if (condition.comparatorOperator == 'isEqualTo') {
      conditionContent += '!value.isAtSameMomentAs(${condition.targetValue})';
    } else if (condition.comparatorOperator == 'isNotEqualTo') {
      conditionContent += 'value.isAtSameMomentAs(${condition.targetValue})';
    } else if (condition.comparatorOperator == 'isLessThan') {
      conditionContent += '!value.isBefore(${condition.targetValue})';
    } else if (condition.comparatorOperator == 'isLessThanOrEqualTo') {
      conditionContent += 'value.isAfter(${condition.targetValue})';
    } else if (condition.comparatorOperator == 'isGreaterThan') {
      conditionContent += '!value.isAfter(${condition.targetValue})';
    } else if (condition.comparatorOperator == 'isGreaterThanOrEqualTo') {
      conditionContent += 'value.isBefore(${condition.targetValue})';
    } else if (condition.comparatorOperator == 'isLessThanCurrentDateTime') {
      conditionContent += '!value.isBefore(DateTime.now())';
    } else if (condition.comparatorOperator ==
        'isLessThanOrEqualToCurrentDateTime') {
      conditionContent += 'value.isAfter(DateTime.now())';
    } else if (condition.comparatorOperator == 'isGreaterThanCurrentDateTime') {
      conditionContent += '!value.isAfter(DateTime.now())';
    } else if (condition.comparatorOperator ==
        'isGreaterThanOrEqualToCurrentDateTime') {
      //ok
      conditionContent += 'value.isBefore(DateTime.now())';
    } else if (condition.comparatorOperator ==
        'isLessThanCurrentDateTimeMinusSeconds') {
      conditionContent +=
          '!value.isBefore(DateTime.now().subtract(const Duration(seconds: ${condition.targetValue})))';
    } else if (condition.comparatorOperator ==
        'isLessThanOrEqualToCurrentDateTimeMinusSeconds') {
      conditionContent +=
          'value.isAfter(DateTime.now().subtract(const Duration(seconds: ${condition.targetValue})))';
    } else if (condition.comparatorOperator ==
        'isGreaterThanCurrentDateTimePlusSeconds') {
      conditionContent +=
          '!value.isAfter(DateTime.now().add(const Duration(seconds: ${condition.targetValue})))';
    } else if (condition.comparatorOperator ==
        'isGreaterThanOrEqualToCurrentDateTimePlusSeconds') {
      //ok
      conditionContent +=
          'value.isBefore(DateTime.now().add(const Duration(seconds: ${condition.targetValue})))';
    } else if (condition.comparatorOperator ==
        'isLessThanCurrentDateTimeMinusMinutes') {
      conditionContent +=
          '!value.isBefore(DateTime.now().subtract(const Duration(minutes: ${condition.targetValue})))';
    } else if (condition.comparatorOperator ==
        'isLessThanOrEqualToCurrentDateTimeMinusMinutes') {
      conditionContent +=
          'value.isAfter(DateTime.now().subtract(const Duration(minutes: ${condition.targetValue})))';
    } else if (condition.comparatorOperator ==
        'isGreaterThanCurrentDateTimePlusMinutes') {
      //ok
      conditionContent +=
          '!value.isAfter(DateTime.now().add(const Duration(minutes: ${condition.targetValue})))';
    } else if (condition.comparatorOperator ==
        'isGreaterThanOrEqualToCurrentDateTimePlusMinutes') {
      //ok
      conditionContent +=
          'value.isBefore(DateTime.now().add(const Duration(minutes: ${condition.targetValue})))';
    } else if (condition.comparatorOperator ==
        'isLessThanCurrentDateTimeMinusHours') {
      conditionContent +=
          '!value.isBefore(DateTime.now().subtract(const Duration(hours: ${condition.targetValue})))';
    } else if (condition.comparatorOperator ==
        'isLessThanOrEqualToCurrentDateTimeMinusHours') {
      conditionContent +=
          'value.isAfter(DateTime.now().subtract(const Duration(hours: ${condition.targetValue})))';
    } else if (condition.comparatorOperator ==
        'isGreaterThanCurrentDateTimePlusHours') {
      conditionContent +=
          '!value.isAfter(DateTime.now().add(const Duration(hours: ${condition.targetValue})))';
    } else if (condition.comparatorOperator ==
        'isGreaterThanOrEqualToCurrentDateTimePlusHours') {
      conditionContent +=
          'value.isBefore(DateTime.now().add(const Duration(hours: ${condition.targetValue})))';
    } else if (condition.comparatorOperator ==
        'isLessThanCurrentDateTimeMinusDays') {
      conditionContent +=
          '!value.isBefore(DateTime.now().subtract(const Duration(days: ${condition.targetValue})))';
    } else if (condition.comparatorOperator ==
        'isLessThanOrEqualToCurrentDateTimeMinusDays') {
      conditionContent +=
          'value.isAfter(DateTime.now().subtract(const Duration(days: ${condition.targetValue})))';
    } else if (condition.comparatorOperator ==
        'isGreaterThanCurrentDateTimePlusDays') {
      conditionContent +=
          '!value.isAfter(DateTime.now().add(const Duration(days: ${condition.targetValue})))';
    } else if (condition.comparatorOperator ==
        'isGreaterThanOrEqualToCurrentDateTimePlusDays') {
      conditionContent +=
          'value.isBefore(DateTime.now().add(const Duration(days: ${condition.targetValue})))';
    }
    return conditionContent;
  }

  static String _generateConditionDate({
    required ValueObjectRuleCondition condition,
    required _ContentParams postRules,
  }) {
    String conditionContent = '';
    if (condition.comparatorOperator == 'isEqualTo') {
      conditionContent += '!value.isAtSameMomentAs(${condition.targetValue})';
    } else if (condition.comparatorOperator == 'isNotEqualTo') {
      conditionContent += 'value.isAtSameMomentAs(${condition.targetValue})';
    } else if (condition.comparatorOperator == 'isLessThan') {
      conditionContent += '!value.isBefore(${condition.targetValue})';
    } else if (condition.comparatorOperator == 'isLessThanOrEqualTo') {
      conditionContent += 'value.isAfter(${condition.targetValue})';
    } else if (condition.comparatorOperator == 'isGreaterThan') {
      conditionContent += '!value.isAfter(${condition.targetValue})';
    } else if (condition.comparatorOperator == 'isGreaterThanOrEqualTo') {
      conditionContent += 'value.isBefore(${condition.targetValue})';
    } else if (condition.comparatorOperator == 'isLessThanCurrentDate') {
      postRules.addPostRule('final now = DateTime.now();');
      postRules.addPostRule(
          'final currentDate = DateTime(now.year, now.month, now.day);');
      conditionContent += '!value.isBefore(currentDate)';
    } else if (condition.comparatorOperator ==
        'isLessThanOrEqualToCurrentDate') {
      postRules.addPostRule('final now = DateTime.now();');
      postRules.addPostRule(
          'final currentDate = DateTime(now.year, now.month, now.day);');
      conditionContent += 'value.isAfter(currentDate)';
    } else if (condition.comparatorOperator == 'isGreaterThanCurrentDate') {
      postRules.addPostRule('final now = DateTime.now();');
      postRules.addPostRule(
          'final currentDate = DateTime(now.year, now.month, now.day);');
      conditionContent += '!value.isAfter(currentDate)';
    } else if (condition.comparatorOperator ==
        'isGreaterThanOrEqualToCurrentDate') {
      postRules.addPostRule('final now = DateTime.now();');
      postRules.addPostRule(
          'final currentDate = DateTime(now.year, now.month, now.day);');
      conditionContent += 'value.isBefore(currentDate)';
    }
    return conditionContent;
  }

  static String _generateConditionTime({
    required ValueObjectRuleCondition condition,
    required _ContentParams postRules,
  }) {
    String conditionContent = '';
    if (condition.comparatorOperator == 'isEqualTo') {
      conditionContent += '!value.isAtSameMomentAs(${condition.targetValue})';
    } else if (condition.comparatorOperator == 'isNotEqualTo') {
      conditionContent += 'value.isAtSameMomentAs(${condition.targetValue})';
    } else if (condition.comparatorOperator == 'isLessThan') {
      conditionContent += '!value.isBefore(${condition.targetValue})';
    } else if (condition.comparatorOperator == 'isLessThanOrEqualTo') {
      conditionContent += 'value.isAfter(${condition.targetValue})';
    } else if (condition.comparatorOperator == 'isGreaterThan') {
      conditionContent += '!value.isAfter(${condition.targetValue})';
    } else if (condition.comparatorOperator == 'isGreaterThanOrEqualTo') {
      conditionContent += 'value.isBefore(${condition.targetValue})';
    } else if (condition.comparatorOperator == 'isLessThanCurrentTime') {
      postRules.addPostRule('final now = DateTime.now();');
      postRules.addPostRule('final currentTime = value.copyWith(');
      postRules.addPostRule('  year: now.year,');
      postRules.addPostRule('  month: now.month,');
      postRules.addPostRule('  day: now.day,');
      postRules.addPostRule(');');
      conditionContent += '!value.isBefore(currentTime)';
    } else if (condition.comparatorOperator ==
        'isLessThanOrEqualToCurrentTime') {
      postRules.addPostRule('final now = DateTime.now();');
      postRules.addPostRule('final currentTime = value.copyWith(');
      postRules.addPostRule('  year: now.year,');
      postRules.addPostRule('  month: now.month,');
      postRules.addPostRule('  day: now.day,');
      postRules.addPostRule(');');
      conditionContent += 'value.isAfter(currentTime)';
    } else if (condition.comparatorOperator == 'isGreaterThanCurrentTime') {
      postRules.addPostRule('final now = DateTime.now();');
      postRules.addPostRule('final currentTime = value.copyWith(');
      postRules.addPostRule('  year: now.year,');
      postRules.addPostRule('  month: now.month,');
      postRules.addPostRule('  day: now.day,');
      postRules.addPostRule(');');
      conditionContent += '!value.isAfter(currentTime)';
    } else if (condition.comparatorOperator ==
        'isGreaterThanOrEqualToCurrentTime') {
      postRules.addPostRule('final now = DateTime.now();');
      postRules.addPostRule('final currentTime = value.copyWith(');
      postRules.addPostRule('  year: now.year,');
      postRules.addPostRule('  month: now.month,');
      postRules.addPostRule('  day: now.day,');
      postRules.addPostRule(');');
      conditionContent += 'value.isBefore(currentTime)';
    } else if (condition.comparatorOperator == 'isLessThanCurrentTimeMinusSeconds') {
      postRules.addPostRule('final now = DateTime.now();');
      postRules.addPostRule('final currentTime = value.copyWith(');
      postRules.addPostRule('  year: now.year,');
      postRules.addPostRule('  month: now.month,');
      postRules.addPostRule('  day: now.day,');
      postRules.addPostRule(');');
      conditionContent += '!value.isBefore(currentTime.subtract(const Duration(seconds: ${condition.targetValue})))';
    } else if (condition.comparatorOperator == 'isLessThanOrEqualToCurrentTimeMinusSeconds') {
      postRules.addPostRule('final now = DateTime.now();');
      postRules.addPostRule('final currentTime = value.copyWith(');
      postRules.addPostRule('  year: now.year,');
      postRules.addPostRule('  month: now.month,');
      postRules.addPostRule('  day: now.day,');
      postRules.addPostRule(');');
      conditionContent += 'value.isAfter(currentTime.subtract(const Duration(seconds: ${condition.targetValue})))';
    } else if (condition.comparatorOperator == 'isGreaterThanCurrentTimePlusSeconds') {
      postRules.addPostRule('final now = DateTime.now();');
      postRules.addPostRule('final currentTime = value.copyWith(');
      postRules.addPostRule('  year: now.year,');
      postRules.addPostRule('  month: now.month,');
      postRules.addPostRule('  day: now.day,');
      postRules.addPostRule(');');
      conditionContent += '!value.isAfter(currentTime.add(const Duration(seconds: ${condition.targetValue})))';
    } else if (condition.comparatorOperator == 'isGreaterThanOrEqualToCurrentTimePlusSeconds') {
      postRules.addPostRule('final now = DateTime.now();');
      postRules.addPostRule('final currentTime = value.copyWith(');
      postRules.addPostRule('  year: now.year,');
      postRules.addPostRule('  month: now.month,');
      postRules.addPostRule('  day: now.day,');
      postRules.addPostRule(');');
      conditionContent += 'value.isBefore(currentTime.add(const Duration(seconds: ${condition.targetValue})))';
    } else if (condition.comparatorOperator == 'isLessThanCurrentTimeMinusMinutes') {
      postRules.addPostRule('final now = DateTime.now();');
      postRules.addPostRule('final currentTime = value.copyWith(');
      postRules.addPostRule('  year: now.year,');
      postRules.addPostRule('  month: now.month,');
      postRules.addPostRule('  day: now.day,');
      postRules.addPostRule(');');
      conditionContent += '!value.isBefore(currentTime.subtract(const Duration(minutes: ${condition.targetValue})))';
    } else if (condition.comparatorOperator == 'isLessThanOrEqualToCurrentTimeMinusMinutes') {
      postRules.addPostRule('final now = DateTime.now();');
      postRules.addPostRule('final currentTime = value.copyWith(');
      postRules.addPostRule('  year: now.year,');
      postRules.addPostRule('  month: now.month,');
      postRules.addPostRule('  day: now.day,');
      postRules.addPostRule(');');
      conditionContent += 'value.isAfter(currentTime.subtract(const Duration(minutes: ${condition.targetValue})))';
    } else if (condition.comparatorOperator == 'isGreaterThanCurrentTimePlusMinutes') {
      postRules.addPostRule('final now = DateTime.now();');
      postRules.addPostRule('final currentTime = value.copyWith(');
      postRules.addPostRule('  year: now.year,');
      postRules.addPostRule('  month: now.month,');
      postRules.addPostRule('  day: now.day,');
      postRules.addPostRule(');');
      conditionContent += '!value.isAfter(currentTime.add(const Duration(minutes: ${condition.targetValue})))';
    } else if (condition.comparatorOperator == 'isGreaterThanOrEqualToCurrentTimePlusMinutes') {
      postRules.addPostRule('final now = DateTime.now();');
      postRules.addPostRule('final currentTime = value.copyWith(');
      postRules.addPostRule('  year: now.year,');
      postRules.addPostRule('  month: now.month,');
      postRules.addPostRule('  day: now.day,');
      postRules.addPostRule(');');
      conditionContent += 'value.isBefore(currentTime.add(const Duration(minutes: ${condition.targetValue})))';
    } else if (condition.comparatorOperator == 'isLessThanCurrentTimeMinusHours') {
      postRules.addPostRule('final now = DateTime.now();');
      postRules.addPostRule('final currentTime = value.copyWith(');
      postRules.addPostRule('  year: now.year,');
      postRules.addPostRule('  month: now.month,');
      postRules.addPostRule('  day: now.day,');
      postRules.addPostRule(');');
      conditionContent += '!value.isBefore(currentTime.subtract(const Duration(hours: ${condition.targetValue})))';
    } else if (condition.comparatorOperator == 'isLessThanOrEqualToCurrentTimeMinusHours') {
      postRules.addPostRule('final now = DateTime.now();');
      postRules.addPostRule('final currentTime = value.copyWith(');
      postRules.addPostRule('  year: now.year,');
      postRules.addPostRule('  month: now.month,');
      postRules.addPostRule('  day: now.day,');
      postRules.addPostRule(');');
      conditionContent += 'value.isAfter(currentTime.subtract(const Duration(hours: ${condition.targetValue})))';
    } else if (condition.comparatorOperator == 'isGreaterThanCurrentTimePlusHours') {
      postRules.addPostRule('final now = DateTime.now();');
      postRules.addPostRule('final currentTime = value.copyWith(');
      postRules.addPostRule('  year: now.year,');
      postRules.addPostRule('  month: now.month,');
      postRules.addPostRule('  day: now.day,');
      postRules.addPostRule(');');
      conditionContent += '!value.isAfter(currentTime.add(const Duration(hours: ${condition.targetValue})))';
    } else if (condition.comparatorOperator == 'isGreaterThanOrEqualToCurrentTimePlusHours') {
      postRules.addPostRule('final now = DateTime.now();');
      postRules.addPostRule('final currentTime = value.copyWith(');
      postRules.addPostRule('  year: now.year,');
      postRules.addPostRule('  month: now.month,');
      postRules.addPostRule('  day: now.day,');
      postRules.addPostRule(');');
      conditionContent += 'value.isBefore(currentTime.add(const Duration(hours: ${condition.targetValue})))';
    }
    return conditionContent;
  }

  static String _generateConditionBoolean(ValueObjectRuleCondition condition) {
    if (condition.comparatorOperator == 'isTrue') {
      return '!value';
    }
    return 'value';
  }
}

String _valueObjectContent = '''
import '../../_core/exception/constraint_error.dart';
import '../../_core/exception/domain_error.dart';
%imports%
class %name% {
  final %type% value;
  
  %name%({
    required this.value, 
    required List<DomainError> errors,
  }) {
    _validate(errors);
  }
  
  void _validate(List<DomainError> errors) {
%domainRules%
  }
}
''';

class _ContentParams {
  final Set<String> _postRules = {};

  void addPostRule(String rule) {
    _postRules.add(rule);
  }

  String get content {
    if (_postRules.isEmpty) {
      return '';
    }
    final postRules = _postRules.map((e) {
      return '    $e';
    }).join('\n');
    return '$postRules\n';
  }
}
