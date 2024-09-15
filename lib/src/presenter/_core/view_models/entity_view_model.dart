import 'package:metamorphis/src/domain/entity/entities/entity.dart';

class EntityViewModel extends Entity {
  EntityViewModel._({
    required super.id,
    required super.name,
    required super.boundedContextId,
    required super.valueObjects,
    required super.useCases,
    required super.entityRules,
    required super.lists,
  });

  factory EntityViewModel.fromEntity(Entity entity) {
    return EntityViewModel._(
      id: entity.id,
      name: entity.name,
      boundedContextId: entity.boundedContextId,
      valueObjects: entity.valueObjects,
      useCases: entity.useCases,
      entityRules: entity.entityRules,
      lists: entity.lists,
    );
  }

  EntityViewModel copyWith({
    String? id,
    String? name,
    String? boundedContextId,
  }) {
    return EntityViewModel._(
      id: id ?? this.id,
      name: name ?? this.name,
      boundedContextId: boundedContextId ?? this.boundedContextId,
      valueObjects: valueObjects,
      useCases: useCases,
      entityRules: entityRules,
      lists: lists,
    );
  }
}
