import 'package:metamorphis/src/domain/value_object/entities/value_object.dart';
import 'package:metamorphis/src/domain/value_object_rule_condition/entities/value_object_rule_condition.dart';

class RustConditionsGenerator {
  static final logics = {'AND': '||', 'OR': '&&'};
  static final _buildFunctions = {
    'String': _buildWithString,
    'byte/int8': _buildWithByte,
    'short/int16': _buildWithShort,
    'int/int32': _buildWithInt,
    'long/int64': _buildWithLong,
    'float/float32': _buildWithFloat,
    'double/float64': _buildWithDouble,
    'BigDecimal': _buildWithBigDecimal,
  };

  static String buildCondition({
    required ValueObjectRuleCondition condition,
    required bool isFirst,
    required ValueObject valueObject,
  }) {
    final buildFunction = _buildFunctions[valueObject.type];
    if (buildFunction != null) {
      return buildFunction(
        condition: condition,
        isFirst: isFirst,
        isNullable: valueObject.isNullable,
      );
    }
    return '';
  }

  static String _buildWithString({
    required ValueObjectRuleCondition condition,
    required bool isFirst,
    required bool isNullable,
  }) {
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

  static String _buildWithByte({
    required ValueObjectRuleCondition condition,
    required bool isFirst,
    required bool isNullable,
  }) {
    final value = condition.targetValue;
    String content = isFirst ? '' : ' ${logics[condition.logicOperator]} ';
    final unwrap = isNullable ? '.clone().unwrap()' : '';
    if (condition.comparatorOperator == 'isEqualTo') {
      content += 'self.value$unwrap != ${value}i8';
    } else if (condition.comparatorOperator == 'isNotEqualTo') {
      content += 'self.value$unwrap == ${value}i8';
    } else if (condition.comparatorOperator == 'isLessThan') {
      content += 'self.value$unwrap >= ${value}i8';
    } else if (condition.comparatorOperator == 'isLessThanOrEqualTo') {
      content += 'self.value$unwrap > ${value}i8';
    } else if (condition.comparatorOperator == 'isGreaterThan') {
      content += 'self.value$unwrap <= ${value}i8';
    } else if (condition.comparatorOperator == 'isGreaterThanOrEqualTo') {
      content += 'self.value$unwrap < ${value}i8';
    }
    return content;
  }

  static String _buildWithShort({
    required ValueObjectRuleCondition condition,
    required bool isFirst,
    required bool isNullable,
  }) {
    final value = condition.targetValue;
    String content = isFirst ? '' : ' ${logics[condition.logicOperator]} ';
    final unwrap = isNullable ? '.clone().unwrap()' : '';
    if (condition.comparatorOperator == 'isEqualTo') {
      content += 'self.value$unwrap != ${value}i16';
    } else if (condition.comparatorOperator == 'isNotEqualTo') {
      content += 'self.value$unwrap == ${value}i16';
    } else if (condition.comparatorOperator == 'isLessThan') {
      content += 'self.value$unwrap >= ${value}i16';
    } else if (condition.comparatorOperator == 'isLessThanOrEqualTo') {
      content += 'self.value$unwrap > ${value}i16';
    } else if (condition.comparatorOperator == 'isGreaterThan') {
      content += 'self.value$unwrap <= ${value}i16';
    } else if (condition.comparatorOperator == 'isGreaterThanOrEqualTo') {
      content += 'self.value$unwrap < ${value}i16';
    }
    return content;
  }

  static String _buildWithInt({
    required ValueObjectRuleCondition condition,
    required bool isFirst,
    required bool isNullable,
  }) {
    final value = condition.targetValue;
    String content = isFirst ? '' : ' ${logics[condition.logicOperator]} ';
    final unwrap = isNullable ? '.clone().unwrap()' : '';
    if (condition.comparatorOperator == 'isEqualTo') {
      content += 'self.value$unwrap != ${value}i32';
    } else if (condition.comparatorOperator == 'isNotEqualTo') {
      content += 'self.value$unwrap == ${value}i32';
    } else if (condition.comparatorOperator == 'isLessThan') {
      content += 'self.value$unwrap >= ${value}i32';
    } else if (condition.comparatorOperator == 'isLessThanOrEqualTo') {
      content += 'self.value$unwrap > ${value}i32';
    } else if (condition.comparatorOperator == 'isGreaterThan') {
      content += 'self.value$unwrap <= ${value}i32';
    } else if (condition.comparatorOperator == 'isGreaterThanOrEqualTo') {
      content += 'self.value$unwrap < ${value}i32';
    }
    return content;
  }

  static String _buildWithLong({
    required ValueObjectRuleCondition condition,
    required bool isFirst,
    required bool isNullable,
  }) {
    final value = condition.targetValue;
    String content = isFirst ? '' : ' ${logics[condition.logicOperator]} ';
    final unwrap = isNullable ? '.clone().unwrap()' : '';
    if (condition.comparatorOperator == 'isEqualTo') {
      content += 'self.value$unwrap != ${value}i64';
    } else if (condition.comparatorOperator == 'isNotEqualTo') {
      content += 'self.value$unwrap == ${value}i64';
    } else if (condition.comparatorOperator == 'isLessThan') {
      content += 'self.value$unwrap >= ${value}i64';
    } else if (condition.comparatorOperator == 'isLessThanOrEqualTo') {
      content += 'self.value$unwrap > ${value}i64';
    } else if (condition.comparatorOperator == 'isGreaterThan') {
      content += 'self.value$unwrap <= ${value}i64';
    } else if (condition.comparatorOperator == 'isGreaterThanOrEqualTo') {
      content += 'self.value$unwrap < ${value}i64';
    }
    return content;
  }

  static String _buildWithFloat({
    required ValueObjectRuleCondition condition,
    required bool isFirst,
    required bool isNullable,
  }) {
    final value = condition.targetValue;
    String content = isFirst ? '' : ' ${logics[condition.logicOperator]} ';
    final unwrap = isNullable ? '.clone().unwrap()' : '';
    if (condition.comparatorOperator == 'isEqualTo') {
      content += 'self.value$unwrap != ${value}f32';
    } else if (condition.comparatorOperator == 'isNotEqualTo') {
      content += 'self.value$unwrap == ${value}f32';
    } else if (condition.comparatorOperator == 'isLessThan') {
      content += 'self.value$unwrap >= ${value}f32';
    } else if (condition.comparatorOperator == 'isLessThanOrEqualTo') {
      content += 'self.value$unwrap > ${value}f32';
    } else if (condition.comparatorOperator == 'isGreaterThan') {
      content += 'self.value$unwrap <= ${value}f32';
    } else if (condition.comparatorOperator == 'isGreaterThanOrEqualTo') {
      content += 'self.value$unwrap < ${value}f32';
    }
    return content;
  }

  static String _buildWithDouble({
    required ValueObjectRuleCondition condition,
    required bool isFirst,
    required bool isNullable,
  }) {
    final value = condition.targetValue;
    String content = isFirst ? '' : ' ${logics[condition.logicOperator]} ';
    final unwrap = isNullable ? '.clone().unwrap()' : '';
    if (condition.comparatorOperator == 'isEqualTo') {
      content += 'self.value$unwrap != ${value}f64';
    } else if (condition.comparatorOperator == 'isNotEqualTo') {
      content += 'self.value$unwrap == ${value}f64';
    } else if (condition.comparatorOperator == 'isLessThan') {
      content += 'self.value$unwrap >= ${value}f64';
    } else if (condition.comparatorOperator == 'isLessThanOrEqualTo') {
      content += 'self.value$unwrap > ${value}f64';
    } else if (condition.comparatorOperator == 'isGreaterThan') {
      content += 'self.value$unwrap <= ${value}f64';
    } else if (condition.comparatorOperator == 'isGreaterThanOrEqualTo') {
      content += 'self.value$unwrap < ${value}f64';
    }
    return content;
  }

  static String _buildWithBigDecimal({
    required ValueObjectRuleCondition condition,
    required bool isFirst,
    required bool isNullable,
  }) {
    final value = condition.targetValue;
    String content = isFirst ? '' : ' ${logics[condition.logicOperator]} ';
    final unwrap = isNullable ? '.clone().unwrap()' : '';
    //self.value < BigDecimal::from_f64(10.5).unwrap()
    if (condition.comparatorOperator == 'isEqualTo') {
      content += 'self.value$unwrap != BigDecimal::from_f64(${value}f64).unwrap()';
    } else if (condition.comparatorOperator == 'isNotEqualTo') {
      content += 'self.value$unwrap == BigDecimal::from_f64(${value}f64).unwrap()';
    } else if (condition.comparatorOperator == 'isLessThan') {
      content += 'self.value$unwrap >= BigDecimal::from_f64(${value}f64).unwrap()';
    } else if (condition.comparatorOperator == 'isLessThanOrEqualTo') {
      content += 'self.value$unwrap > BigDecimal::from_f64(${value}f64).unwrap()';
    } else if (condition.comparatorOperator == 'isGreaterThan') {
      content += 'self.value$unwrap <= BigDecimal::from_f64(${value}f64).unwrap()';
    } else if (condition.comparatorOperator == 'isGreaterThanOrEqualTo') {
      content += 'self.value$unwrap < BigDecimal::from_f64(${value}f64).unwrap()';
    }
    return content;
  }
}
