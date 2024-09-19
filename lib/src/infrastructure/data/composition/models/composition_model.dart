import 'package:metamorphis/src/domain/composition/entities/composition.dart';
import 'package:metamorphis/src/domain/entity/entities/entity.dart';

class CompositionModel extends Composition {
  CompositionModel({
    required super.id,
    required super.name,
    required super.entity,
    required super.compositionType,
  });

  factory CompositionModel.fromEntity(Composition composition) {
    return CompositionModel(
      id: composition.id,
      name: composition.name,
      entity: composition.entity,
      compositionType: composition.compositionType,
    );
  }

  factory CompositionModel.fromMap(Map<String, dynamic> json) {
    return CompositionModel(
      id: json['id'],
      name: json['name'],
      entity: Entity(
        id: json['entityId'],
        name: json['entityName'],
        boundedContextId: '',
      ),
      compositionType: CompositionType.fromString(
        json['compositionType'] ?? '',
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': super.id,
      'name': super.name,
      'entityId': super.entity.id,
      'entityName': super.entity.name,
      'compositionType': super.compositionType.name,
    };
  }
}
