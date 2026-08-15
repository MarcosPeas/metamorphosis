import 'package:metamorphis/src/domain/versioned_entity/entities/value_object_screeshot.dart';

extension DBTypeExtension on ValueObjectScreeshot  {
  String toMySqlType(int maxLength) {
    Map<String, String> types = {
      'bool': 'BOOLEAN',
      'byte/int8': 'INT',
      'short/int16': 'INT',
      'int/int32': 'INT',
      'long/int64': 'BIGINT',
      'float/float32': 'REAL',
      'double/float64': 'DOUBLE',
      'BigDecimal': 'REAL',
      'String': 'VARCHAR',
      'Date': 'TIMESTAMP',
      'Time': 'TIMESTAMP',
      'DateTime': 'TIMESTAMP',
      'Enum': 'String',
    };
    String result;
    if (type == 'String') {
      result = 'VARCHAR(${maxLength})';
    } else {
      result = types.containsKey(type) ? types[type]! : type;
    }
    if (isNullable) {
      return '$result NULL';
    }
    return '$result NOT NULL';
  }
}
