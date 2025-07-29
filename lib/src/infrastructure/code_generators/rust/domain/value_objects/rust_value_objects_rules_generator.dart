import 'package:change_case/change_case.dart';
import 'package:metamorphis/src/domain/entity/entities/entity.dart';
import 'package:metamorphis/src/domain/value_object/entities/value_object.dart';

import 'rust_conditions_generator.dart';

class RustValueObjectsRulesGenerator {
  static String generate(Entity entity, ValueObject valueObject) {
    final entityNamePascal = entity.name.toPascalCase();
    final valueObjectNamePascal = valueObject.name.toPascalCase();
    final valueObjectFullName = '$entityNamePascal$valueObjectNamePascal';
    String totalContentRules = '';
    final rules = valueObject.rules;
    for (final rule in rules) {
      final groupsConditions = rule.groupConditions;
      String ruleContent = '';
      final parenthesesL = groupsConditions.length > 1 ? '(' : '';
      final parenthesesR = groupsConditions.length > 1 ? ')' : '';
      ruleContent += '\n        if ';
      for (int i = 0; i < groupsConditions.length; i++) {
        final group = groupsConditions[i];
        ruleContent += i == 0
            ? ''
            : ' ${RustConditionsGenerator.logics[group.logicOperator]} ';
        ruleContent += parenthesesL;
        final conditions = group.conditions;
        for (int y = 0; y < conditions.length; y++) {
          final condition = conditions[y];
          ruleContent += RustConditionsGenerator.buildCondition(
            valueObject: valueObject,
            condition: condition,
            isFirst: y == 0,
          );
        }
        ruleContent += parenthesesR;
      }
      String errorContent = _addErrorTemplate.replaceAll(
        '{message}',
        rule.errorMessage,
      );
      errorContent = errorContent.replaceAll('{context}', valueObjectFullName);
      errorContent = errorContent.replaceAll(
        '{trace}',
        '$valueObjectFullName.validate',
      );
      ruleContent += ' {';
      ruleContent += '\n$errorContent';
      ruleContent += '\n        }';
      totalContentRules += ruleContent;
    }
    if (valueObject.isNullable) {
      return _noneSafe + totalContentRules;
    }
    return totalContentRules;
  }
}

const _noneSafe = '''
\n        if self.value.is_none() {
            return;
        }''';
const _addErrorTemplate = '''             errors.push(DomainError::new(
                String::from("{message}"),
                String::from("{context}"),
                String::from("{trace}"),
            ));''';
