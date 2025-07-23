import 'dart:convert';

import 'package:metamorphis/src/domain/field/entities/field.dart';

class FieldModel extends Field {
  FieldModel({
    required super.id,
    required super.name,
    required super.type,
    required super.isNullable,
    required super.enumName,
    required super.enumValues,
    required super.dataClassId,
  });

  factory FieldModel.fromEntity(Field field) {
    return FieldModel(
      id: field.id,
      name: field.name,
      type: field.type,
      isNullable: field.isNullable,
      enumName: field.enumName,
      enumValues: field.enumValues,
      dataClassId: field.dataClassId,
    );
  }

  factory FieldModel.fromMap(Map<String, dynamic> json) {
    return FieldModel(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      isNullable: json['isNullable'] ?? false,
      enumName: json['enumName'] ?? '',
      enumValues: json['enumValues'] ?? '',
      dataClassId: json['dataClassId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': super.id,
      'name': super.name,
      'type': super.type,
      'isNullable': super.isNullable,
      'enumName': super.enumName,
      'enumValues': super.enumValues,
      'dataClassId': super.dataClassId,
    };
  }

  factory FieldModel.fromJson(String json) {
    return FieldModel.fromMap(jsonDecode(json));
  }

  String toJson() {
    return jsonEncode(toMap());
  }
}
