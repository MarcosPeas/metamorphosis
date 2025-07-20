
import 'package:metamorphis/src/domain/composition/entities/composition.dart';
import 'package:metamorphis/src/domain/entity/entities/entity.dart';

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

  factory ReferenceModel.fromMap(Map<String, dynamic> json) {
    return ReferenceModel(
      id: json['id'],
      name: json['name'],
      entity: Entity(
        id: json['entityId'],
        name: json['entityName'],
        applicationId: '',
      ),
      referenceType: ReferenceType.fromString(
        json['referenceType'] ?? '',
      ),
    );
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
}
