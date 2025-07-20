import 'package:change_case/change_case.dart';
import 'package:uuid/uuid.dart';

class Enumerator {
  late final String id;
  String name;
  late String _values;

  Enumerator({String? id, required this.name, required String values}) {
    this.id = id ?? const Uuid().v7();
    _addValues(values);
  }

  String get values => _values;

  List<String> get valuesList {
    return _values.split(',').map((e) => e.trim()).toList();
  }

  void addValue(String value) {
    if (_values.isEmpty) {
      _values = value.toConstantCase();
    } else {
      _values += ',${value.toConstantCase()}';
    }
  }

  void _addValues(String values) {
    String result = values.trim();
    while(result.contains('  ')) {
      result = result.replaceAll('  ', ' ');
    }
    while(result.contains(',,')) {
      result = result.replaceAll(',,', ',');
    }
    if (result.endsWith(',')) {
      result = result.substring(0, result.length - 1);
    }
    if (result.startsWith(',')) {
      result = result.substring(1);
    }
    _values = result;
  }

  void removeValue(String value) {
    final valuesList = _values.split(',');
    valuesList.remove(value.toConstantCase());
    _values = valuesList.join(',');
  }
}
