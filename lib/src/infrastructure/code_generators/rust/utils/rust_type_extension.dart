import 'package:metamorphis/src/domain/value_object/entities/value_object.dart';

extension RustTypeExtension on ValueObject {
  String toRustType() {
    Map<String, String> types = {
      'bool': 'bool',
      'byte/int8': 'i8',
      'short/int16': 'i16',
      'int/int32': 'i32',
      'long/int64': 'i64',
      'float/float32': 'f32',
      'double/float64': 'f64',
      'BigDecimal': 'BigDecimal',
      'String': 'String',
      'Date': 'DateTime<Utc>',
      'Time': 'DateTime<Utc>',
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
