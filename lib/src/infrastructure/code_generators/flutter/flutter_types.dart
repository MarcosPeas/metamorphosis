class FlutterTypes {
  static final _types = {
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

  static String getType(String type) {
    return _types[type] ?? '';
  }
}