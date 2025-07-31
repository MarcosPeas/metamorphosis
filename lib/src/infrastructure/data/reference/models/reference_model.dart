import 'dart:convert';

import 'package:metamorphis/src/domain/entity/entities/entity.dart';
import 'package:metamorphis/src/domain/reference/entities/reference.dart';

class ReferenceModel extends Reference {
  ReferenceModel({
    required super.id,
    required super.name,
    required super.entity,
    required super.referenceType,
  });

  factory ReferenceModel.fromEntity(Reference reference) {
    return ReferenceModel(
      id: reference.id,
      name: reference.name,
      entity: reference.entity,
      referenceType: reference.referenceType,
    );
  }

  factory ReferenceModel.fromMap(Map<String, dynamic> map) {
    return ReferenceModel(
      id: map['id'],
      name: map['name'],
      entity: Entity(
        id: map['entityId'],
        name: map['entityName'],
        applicationId: '',
      ),
      referenceType: ReferenceType.fromString(map['referenceType'] ?? ''),
    );
  }

  factory ReferenceModel.fromJson(String json) {
    return ReferenceModel.fromMap(jsonDecode(json));
  }

  Map<String, dynamic> toMap() {
    return {
      'id': super.id,
      'name': super.name,
      'entityId': super.entity.id,
      'entityName': super.entity.name,
      'referenceType': super.referenceType.name,
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }
}
