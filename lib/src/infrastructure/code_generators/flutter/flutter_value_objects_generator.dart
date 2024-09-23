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

    final domainRules = _generateRules(valueObject);

    content = content.replaceAll(
      '%domainRules%',
      domainRules,
    );

    final bytes = utf8.encode(content);
    return ArchiveFile.noCompress(
      '$entityPath/value_objects/$snackName.dart',
      bytes.length,
      bytes,
    );
  }

  static String _generateRules(ValueObject valueObject) {
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
          groupContent += _generateCondition(condition);
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

  static String _generateCondition(ValueObjectRuleCondition condition) {
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
    }
    if (conditionContent.isEmpty) {
      conditionContent = 'false';
    }
    return conditionContent;
  }
}

String _valueObjectContent = '''
import '../../_core/exception/constraint_error.dart';
import '../../_core/exception/domain_error.dart';

class %name% {

  final %type% value;
  
  %name%({required this.value, required List<DomainError> errors}) {
    _validate(errors);
  }
  
  void _validate(List<DomainError> errors) {
%domainRules%
  }
}
''';
