import 'dart:convert';

import 'package:metamorphis/src/domain/data_class/entities/data_class.dart';
import 'package:metamorphis/src/domain/field/entities/field.dart';
import 'package:metamorphis/src/infrastructure/data/field/models/field_model.dart';

class DataClassModel extends DataClass {
  DataClassModel({
    required super.id,
    required super.name,
    required super.dataClassType,
    required super.fields,
    required super.useCaseId,
    required super.isList,
  });

  static DataClassModel? fromEntity(DataClass? dataClass) {
    if (dataClass == null) {
      return null;
    }
    return DataClassModel(
      id: dataClass.id,
      name: dataClass.name,
      dataClassType: dataClass.dataClassType,
      fields: dataClass.fields.map(FieldModel.fromEntity).toList(),
      useCaseId: dataClass.useCaseId,
      isList: dataClass.isList,
    );
  }

  static DataClassModel? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    List<Field> fields = [];
    if (map['fields'] != null && map['fields'] is List) {
      final List<dynamic> fieldsMap = map['fields'];
      for (final fieldMap in fieldsMap) {
        final field = FieldModel.fromMap(fieldMap);
        fields.add(field);
      }
    }
    return DataClassModel(
      id: map['id'],
      name: map['name'],
      dataClassType: DataClassType.fromString(map['dataClassType']),
      fields: fields,
      useCaseId: map['useCaseId'],
      isList: map['isList'] ?? false,
    );
  }

  static DataClassModel? fromJson(String? json) {
    if (json == null || json.isEmpty) {
      return null;
    }
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
      'isList': isList,
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }
}
