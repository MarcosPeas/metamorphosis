import 'package:metamorphis/src/domain/entity/entities/entity.dart';

class EntityViewModel extends Entity {
  EntityViewModel._({
    required super.id,
    required super.name,
    required super.applicationId,
    required super.valueObjects,
    required super.useCases,
    required super.entityRules,
    required super.compositions,
  });

  factory EntityViewModel.fromEntity(Entity entity) {
    return EntityViewModel._(
      id: entity.id,
      name: entity.name,
      applicationId: entity.applicationId,
      valueObjects: entity.valueObjects,
      useCases: entity.useCases,
      entityRules: entity.entityRules,
      compositions: entity.compositions,
    );
  }

  EntityViewModel copyWith({
    String? id,
    String? name,
    String? applicationId,
  }) {
    return EntityViewModel._(
      id: id ?? this.id,
      name: name ?? this.name,
      applicationId: applicationId ?? this.applicationId,
      valueObjects: valueObjects,
      useCases: useCases,
      entityRules: entityRules,
      compositions: compositions,
    );
  }
}
