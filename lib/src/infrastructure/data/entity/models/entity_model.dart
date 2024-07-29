import 'package:metamorphis/src/domain/entity/entities/entity.dart';

class EntityModel extends Entity {
  EntityModel({
    required super.id,
    required super.name,
    required super.boundedContextId,
  });

  factory EntityModel.fromEntity(Entity entity) {
    return EntityModel(
      id: entity.id,
      name: entity.name,
      boundedContextId: entity.boundedContextId,
    );
  }

  factory EntityModel.fromMap(Map<String, dynamic> json) {
    return EntityModel(
      id: json['id'],
      name: json['name'],
      boundedContextId: json['boundedContextId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'boundedContextId': boundedContextId,
    };
  }
}
