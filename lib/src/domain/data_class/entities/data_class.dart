import 'package:metamorphis/src/domain/_core/domain/id_generator.dart';
import 'package:metamorphis/src/domain/field/entities/field.dart';

class DataClass {
  late final String id;
  String name;
  final DataClassType dataClassType;
  final List<Field> _fields = [];
  final String useCaseId;
  final bool isList;

  DataClass({
    String? id,
    required this.name,
    required this.dataClassType,
    List<Field>? fields,
    required this.useCaseId,
    this.isList = false,
  }) {
    this.id = id ?? IdGenerator.generateId();
    if (fields != null) {
      _fields.addAll(fields);
    }
  }

  List<Field> get fields => _fields;

  void addField(Field field) {
    _fields.add(field);
  }

  void removeField(Field field) {
    _fields.remove(field);
  }
}

enum DataClassType {
  input('input'),
  output('output');

  final String value;

  const DataClassType(this.value);

  static DataClassType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'input':
        return DataClassType.input;
      case 'output':
        return DataClassType.output;
      default:
        return DataClassType.input;
    }
  }
}
