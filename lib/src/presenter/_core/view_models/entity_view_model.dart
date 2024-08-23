import 'package:metamorphis/src/domain/entity/entities/entity.dart';

class EntityViewModel extends Entity {
  EntityViewModel({
    required super.id,
    required super.name,
    required super.boundedContextId,
    super.valueObjects,
    super.useCases,
  });

  factory EntityViewModel.fromEntity(Entity entity) {
    return EntityViewModel(
      id: entity.id,
      name: entity.name,
      boundedContextId: entity.boundedContextId,
      valueObjects: entity.valueObjects,
      useCases: entity.useCases,
    );
  }

  EntityViewModel copyWith({
    String? id,
    String? name,
    String? boundedContextId,
  }) {
    return EntityViewModel(
      id: id ?? this.id,
      name: name ?? this.name,
      boundedContextId: boundedContextId ?? this.boundedContextId,
      valueObjects: valueObjects,
      useCases: useCases,
    );
  }
}
