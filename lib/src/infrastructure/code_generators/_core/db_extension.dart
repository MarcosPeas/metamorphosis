import 'package:metamorphis/src/domain/value_object/entities/value_object.dart';

extension DBTypeExtension on ValueObject {
  String toDBType() {
    Map<String, String> types = {
      'bool': 'BOOLEAN',
      'byte/int8': 'INTEGER',
      'short/int16': 'INTEGER',
      'int/int32': 'INTEGER',
      'long/int64': 'BIGINT',
      'float/float32': 'REAL',
      'double/float64': 'DOUBLE PRECISION',
      'BigDecimal': 'REAL',
      'String': 'VARCHAR',
      'Date': 'TIMESTAMP',
      'Time': 'TIMESTAMP',
      'DateTime': 'DateTime<Utc>',
      'Enum': 'String',
    };
    final result = types.containsKey(type) ? types[type]! : type;
    if (isNullable) {
      return 'Option<$result>';
    }
    return result;
  }
}