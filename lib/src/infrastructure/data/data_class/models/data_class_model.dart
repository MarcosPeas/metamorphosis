import 'dart:convert';

import 'package:metamorphis/src/domain/data_class/entities/data_class.dart';
import 'package:metamorphis/src/infrastructure/data/field/models/field_model.dart';

class DataClassModel extends DataClass {
  DataClassModel({
    required super.id,
    required super.name,
    required super.dataClassType,
    required super.fields,
    required super.useCaseId,
  });

  factory DataClassModel.fromEntity(DataClass dataClass) {
    return DataClassModel(
      id: dataClass.id,
      name: dataClass.name,
      dataClassType: dataClass.dataClassType,
      fields: dataClass.fields.map(FieldModel.fromEntity).toList(),
      useCaseId: dataClass.useCaseId,
    );
  }

  factory DataClassModel.fromMap(Map<String, dynamic> json) {
    List<Map<String, dynamic>> fields = [];
    if (json['fields'] != null) {
      fields = json['fields'];
    }
    return DataClassModel(
      id: json['id'],
      name: json['name'],
      dataClassType: DataClassType.fromString(json['dataClassType']),
      fields: fields.map(FieldModel.fromMap).toList(),
      useCaseId: json['useCaseId'],
    );
  }

  factory DataClassModel.fromJson(String json) {
    return DataClassModel.fromMap(jsonDecode(json));
  }

  Map<String, dynamic> toMap() {
    final fieldsModel = fields.map((field) {
      return FieldModel.fromEntity(field).toMap();
    }).toList();
    return {
      'id': id,
      'name': name,
      'dataClassType': dataClassType.value,
      'fields': fieldsModel,
      'useCaseId': useCaseId,
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }
}
