extension RustTypeExtension on String {
  String toRustType() {
    Map<String, String> types = {
      'bool': 'bool',
      'byte/int8': 'i8',
      'short/int16': 'i16',
      'int/int32': 'i32',
      'long/int64': 'i64',
      'float/float32': 'f32',
      'double/float64': 'f64',
      'BigDecimal': 'f64',
      'String': 'String',
      'Date': 'DateTime<Utc>',
      'Time': 'DateTime<Utc>',
      'DateTime': 'DateTime<Utc>',
      'Enum': 'String',
    };
    return types.containsKey(this) ? types[this]! : this;
  }
}
