import 'package:metamorphis/src/domain/_core/domain/id_generator.dart';

class Field {
  late final String id;
  String name;
  String type;
  bool isNullable;
  String enumName;
  String enumValues;
  final String dataClassId;

  Field({
    String? id,
    required this.name,
    required this.type,
    this.isNullable = false,
    this.enumName = '',
    this.enumValues = '',
    required this.dataClassId,
  }) {
    this.id = id ?? IdGenerator.generateId();
  }
}