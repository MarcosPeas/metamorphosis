import 'package:change_case/change_case.dart';
import 'package:metamorphis/src/domain/entity/entities/entity.dart';
import 'package:metamorphis/src/domain/value_object/entities/value_object.dart';
import 'package:metamorphis/src/domain/value_object_rule_condition/entities/value_object_rule_condition.dart';

class RustValueObjectsRulesGenerator {
  static final logics = {'AND': '||', 'OR': '&&'};

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
        ruleContent += i == 0 ? '' : ' ${logics[group.logicOperator]} ';
        ruleContent += parenthesesL;
        final conditions = group.conditions;
        for (int y = 0; y < conditions.length; y++) {
          final condition = conditions[y];
          if (valueObject.isString) {
            ruleContent += _buildWithString(
              condition,
              y == 0,
              valueObject.isNullable,
            );
          }
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

  static String _buildWithString(
    ValueObjectRuleCondition condition,
    bool isFirst,
    bool isNullable,
  ) {
    final value = condition.targetValue;
    String content = isFirst ? '' : ' ${logics[condition.logicOperator]} ';
    final unwrap = isNullable ? '.clone().unwrap()' : '';
    if (condition.comparatorOperator == 'isNotEmpty') {
      content += 'self.value$unwrap.is_empty()';
    } else if (condition.comparatorOperator == 'minLength') {
      content += 'self.value$unwrap.len() < $value';
    } else if (condition.comparatorOperator == 'maxLength') {
      content += 'self.value$unwrap.len() > $value';
    } else if (condition.comparatorOperator == 'equals') {
      content += 'self.value$unwrap != "$value"';
    } else if (condition.comparatorOperator == 'notEquals') {
      content += 'self.value$unwrap == "$value"';
    } else if (condition.comparatorOperator == 'lengthEquals') {
      content += 'self.value$unwrap.len() != $value';
    } else if (condition.comparatorOperator == 'isEmail') {
      content += '!EmailAddress::is_valid(&self.value$unwrap)';
    } else if (condition.comparatorOperator == 'isCpf') {
      content += '!cpf::validate(&self.value$unwrap)';
    } else if (condition.comparatorOperator == 'isCnpj') {
      content += '!cnpj::validate(&self.value$unwrap)';
    } else if (condition.comparatorOperator == 'isUrl') {
      content += '!Url::parse(&self.value$unwrap).is_ok()';
    } else if (condition.comparatorOperator == 'matches') {
      content += '!Regex::new(r"$value").unwrap().is_match(&self.value$unwrap)';
    }
    return content;
  }

  static String _buildWithNumber() {
    return '';
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
