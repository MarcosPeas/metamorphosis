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
    'Date': _buildWithAnyDate,
    'Time': _buildWithTime,
    'DateTime': _buildWithDateTime,
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

  static String _buildWithDateTime({
    required ValueObjectRuleCondition condition,
    required bool isFirst,
    required bool isNullable,
  }) {
    String value = condition.targetValue ?? '';
    if (value.contains('.')) {
      value = '${value.substring(0, value.length - 1)}Z';
    }
    String content = isFirst ? '' : ' ${logics[condition.logicOperator]} ';
    final unwrap = isNullable ? '.clone().unwrap()' : '';
    if (condition.comparatorOperator == 'isEqualTo') {
      content += 'self.value$unwrap != DateTime::parse_from_rfc3339("$value").unwrap()';
    } else if (condition.comparatorOperator == 'isNotEqualTo') {
      content += 'self.value$unwrap == DateTime::parse_from_rfc3339("$value").unwrap()';
    } else if (condition.comparatorOperator == 'isLessThan') {
      content += 'self.value$unwrap >= DateTime::parse_from_rfc3339("$value").unwrap()';
    } else if (condition.comparatorOperator == 'isLessThanOrEqualTo') {
      content += 'self.value$unwrap > DateTime::parse_from_rfc3339("$value").unwrap()';
    } else if (condition.comparatorOperator == 'isGreaterThan') {
      content += 'self.value$unwrap <= DateTime::parse_from_rfc3339("$value").unwrap()';
    } else if (condition.comparatorOperator == 'isGreaterThanOrEqualTo') {
      content += 'self.value$unwrap < DateTime::parse_from_rfc3339("$value").unwrap()';
    } else if (condition.comparatorOperator == 'isLessThanCurrentDateTime') {
      content += 'self.value$unwrap >= Utc::now()';
    } else if (condition.comparatorOperator == 'isLessThanOrEqualToCurrentDateTime') {
      content += 'self.value$unwrap > Utc::now()';
    } else if (condition.comparatorOperator == 'isGreaterThanCurrentDateTime') {
      content += 'self.value$unwrap <= Utc::now()';
    } else if (condition.comparatorOperator == 'isGreaterThanOrEqualToCurrentDateTime') {
      content += 'self.value$unwrap < Utc::now()';
    } else if (condition.comparatorOperator == 'isLessThanCurrentDateTimeMinusSeconds') {
      content += 'self.value$unwrap >= (Utc::now() - Duration::seconds($value))';
    } else if (condition.comparatorOperator == 'isLessThanOrEqualToCurrentDateTimeMinusSeconds') {
      content += 'self.value$unwrap > (Utc::now() - Duration::seconds($value))';
    } else if (condition.comparatorOperator == 'isGreaterThanCurrentDateTimePlusSeconds') {
      content += 'self.value$unwrap <= (Utc::now() + Duration::seconds($value))';
    } else if (condition.comparatorOperator == 'isGreaterThanOrEqualToCurrentDateTimePlusSeconds') {
      content += 'self.value$unwrap < (Utc::now() + Duration::seconds($value))';
    } else if (condition.comparatorOperator == 'isLessThanCurrentDateTimeMinusMinutes') {
      content += 'self.value$unwrap >= (Utc::now() - Duration::minutes($value))';
    } else if (condition.comparatorOperator == 'isLessThanOrEqualToCurrentDateTimeMinusMinutes') {
      content += 'self.value$unwrap > (Utc::now() - Duration::minutes($value))';
    } else if (condition.comparatorOperator == 'isGreaterThanCurrentDateTimePlusMinutes') {
      content += 'self.value$unwrap <= (Utc::now() + Duration::minutes($value))';
    } else if (condition.comparatorOperator == 'isGreaterThanOrEqualToCurrentDateTimePlusMinutes') {
      content += 'self.value$unwrap < (Utc::now() + Duration::minutes($value))';
    } else if (condition.comparatorOperator == 'isLessThanCurrentDateTimeMinusHours') {
      content += 'self.value$unwrap >= (Utc::now() - Duration::hours($value))';
    } else if (condition.comparatorOperator == 'isLessThanOrEqualToCurrentDateTimeMinusHours') {
      content += 'self.value$unwrap > (Utc::now() - Duration::hours($value))';
    } else if (condition.comparatorOperator == 'isGreaterThanCurrentDateTimePlusHours') {
      content += 'self.value$unwrap <= (Utc::now() + Duration::hours($value))';
    } else if (condition.comparatorOperator == 'isGreaterThanOrEqualToCurrentDateTimePlusHours') {
      content += 'self.value$unwrap < (Utc::now() + Duration::hours($value))';
    } else if (condition.comparatorOperator == 'isLessThanCurrentDateTimeMinusDays') {
      content += 'self.value$unwrap >= (Utc::now() - Duration::days($value))';
    } else if (condition.comparatorOperator == 'isLessThanOrEqualToCurrentDateTimeMinusDays') {
      content += 'self.value$unwrap > (Utc::now() - Duration::days($value))';
    } else if (condition.comparatorOperator == 'isGreaterThanCurrentDateTimePlusDays') {
      content += 'self.value$unwrap <= (Utc::now() + Duration::days($value))';
    } else if (condition.comparatorOperator == 'isGreaterThanOrEqualToCurrentDateTimePlusDays') {
      content += 'self.value$unwrap < (Utc::now() + Duration::days($value))';
    }
    return content;
  }

  static String _buildWithTime({
    required ValueObjectRuleCondition condition,
    required bool isFirst,
    required bool isNullable,
  }) {
    String value = condition.targetValue ?? '';
    if (value.contains('.')) {
      value = '${value.substring(0, value.length - 1)}Z';
      print(value);
      final date = DateTime.parse(value);
      value = date.toUtc().toIso8601String();
      value = '${value.substring(0, value.length - 1)}Z';
      print(value);
    }
    String content = isFirst ? '' : ' ${logics[condition.logicOperator]} ';
    String unwrap = isNullable ? '.clone().unwrap()' : '';
    unwrap += '.time()';
    if (condition.comparatorOperator == 'isEqualTo') {
      content += 'self.value$unwrap != DateTime::parse_from_rfc3339("$value").unwrap().time()';
    } else if (condition.comparatorOperator == 'isNotEqualTo') {
      content += 'self.value$unwrap == DateTime::parse_from_rfc3339("$value").unwrap().time()';
    } else if (condition.comparatorOperator == 'isLessThan') {
      content += 'self.value$unwrap >= DateTime::parse_from_rfc3339("$value").unwrap().time()';
    } else if (condition.comparatorOperator == 'isLessThanOrEqualTo') {
      content += 'self.value$unwrap > DateTime::parse_from_rfc3339("$value").unwrap().time()';
    } else if (condition.comparatorOperator == 'isGreaterThan') {
      content += 'self.value$unwrap <= DateTime::parse_from_rfc3339("$value").unwrap().time()';
    } else if (condition.comparatorOperator == 'isGreaterThanOrEqualTo') {
      content += 'self.value$unwrap < DateTime::parse_from_rfc3339("$value").unwrap().time()';
    } else if (condition.comparatorOperator == 'isLessThanCurrentTime') {
      content += 'self.value$unwrap >= Utc::now().time()';
    } else if (condition.comparatorOperator == 'isLessThanOrEqualToCurrentTime') {
      content += 'self.value$unwrap > Utc::now().time()';
    } else if (condition.comparatorOperator == 'isGreaterThanCurrentTime') {
      content += 'self.value$unwrap <= Utc::now().time()';
    } else if (condition.comparatorOperator == 'isGreaterThanOrEqualToCurrentTime') {
      content += 'self.value$unwrap < Utc::now().time()';
    } else if (condition.comparatorOperator == 'isLessThanCurrentTimeMinusSeconds') {
      content += 'self.value$unwrap >= (Utc::now().time() - Duration::seconds($value))';
    } else if (condition.comparatorOperator == 'isLessThanOrEqualToCurrentTimeMinusSeconds') {
      content += 'self.value$unwrap > (Utc::now().time() - Duration::seconds($value))';
    } else if (condition.comparatorOperator == 'isGreaterThanCurrentTimePlusSeconds') {
      content += 'self.value$unwrap <= (Utc::now().time() + Duration::seconds($value))';
    } else if (condition.comparatorOperator == 'isGreaterThanOrEqualToCurrentTimePlusSeconds') {
      content += 'self.value$unwrap < (Utc::now().time() + Duration::seconds($value))';
    } else if (condition.comparatorOperator == 'isLessThanCurrentTimeMinusMinutes') {
      content += 'self.value$unwrap >= (Utc::now().time() - Duration::minutes($value))';
    } else if (condition.comparatorOperator == 'isLessThanOrEqualToCurrentTimeMinusMinutes') {
      content += 'self.value$unwrap > (Utc::now().time() - Duration::minutes($value))';
    } else if (condition.comparatorOperator == 'isGreaterThanCurrentTimePlusMinutes') {
      content += 'self.value$unwrap <= (Utc::now().time() + Duration::minutes($value))';
    } else if (condition.comparatorOperator == 'isGreaterThanOrEqualToCurrentTimePlusMinutes') {
      content += 'self.value$unwrap < (Utc::now().time() + Duration::minutes($value))';
    } else if (condition.comparatorOperator == 'isLessThanCurrentTimeMinusHours') {
      content += 'self.value$unwrap >= (Utc::now().time() - Duration::hours($value))';
    } else if (condition.comparatorOperator == 'isLessThanOrEqualToCurrentTimeMinusHours') {
      content += 'self.value$unwrap > (Utc::now().time() - Duration::hours($value))';
    } else if (condition.comparatorOperator == 'isGreaterThanCurrentTimePlusHours') {
      content += 'self.value$unwrap <= (Utc::now().time() + Duration::hours($value))';
    } else if (condition.comparatorOperator == 'isGreaterThanOrEqualToCurrentTimePlusHours') {
      content += 'self.value$unwrap < (Utc::now().time() + Duration::hours($value))';
    }
    return content;
  }

  static String _buildWithAnyDate({
    required ValueObjectRuleCondition condition,
    required bool isFirst,
    required bool isNullable,
  }) {
    final value = condition.targetValue;
    String content = isFirst ? '' : ' ${logics[condition.logicOperator]} ';
    final unwrap = isNullable ? '.clone().unwrap()' : '';
    if (condition.comparatorOperator == 'isEqualTo') {
      content += 'self.value$unwrap == BigDecimal::from_f64(${value}f64).unwrap()';
    }
    return content;
  }
}
