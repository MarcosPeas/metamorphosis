import 'dart:convert';

import 'package:metamorphis/src/domain/entity/entities/entity.dart';
import 'package:metamorphis/src/domain/global_enumerator/entities/global_enumerator.dart';
import 'package:metamorphis/src/infrastructure/data/entity/models/entity_model.dart';

class GlobalEnumeratorModel extends GlobalEnumerator {
  GlobalEnumeratorModel({
    required super.id,
    required super.name,
    required super.description,
    required super.values,
    required super.entities,
    required super.applicationId,
    required super.createdAt,
  });

  factory GlobalEnumeratorModel.fromEntity(GlobalEnumerator globalEnumerator) {
    return GlobalEnumeratorModel(
      id: globalEnumerator.id,
      name: globalEnumerator.name,
      description: globalEnumerator.description,
      values: globalEnumerator.values,
      entities: globalEnumerator.entities,
      applicationId: globalEnumerator.applicationId,
      createdAt: globalEnumerator.createdAt,
    );
  }

  factory GlobalEnumeratorModel.fromMap(Map<String, dynamic> map) {
    final String values = map['values'];
    final entities = <Entity>[];
    if (map['entities'] != null && map['entities'] is List) {
      final entitiesDoc = map['entities'] as List;
      for (final entityDoc in entitiesDoc) {
        final entity = EntityModel.fromShortMap(entityDoc);
        entities.add(entity);
      }
    }
    return GlobalEnumeratorModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      values: values,
      entities: entities,
      applicationId: map['applicationId'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  factory GlobalEnumeratorModel.fromShortMap(Map<String, dynamic> map) {
    final String values = map['values'];
    return GlobalEnumeratorModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      values: values,
      entities: [],
      applicationId: map['applicationId'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  factory GlobalEnumeratorModel.fromJson(String json) {
    final map = Map<String, dynamic>.from(jsonDecode(json));
    return GlobalEnumeratorModel.fromMap(map);
  }

  Map<String, dynamic> toMap() {
    final entities = this.entities.map((e) {
      final model = EntityModel.fromEntity(e);
      return model.toMap();
    }).toList();
    return {
      'id': id,
      'name': name,
      'description': description,
      'values': values,
      'entities': entities,
      'applicationId': applicationId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }
}
