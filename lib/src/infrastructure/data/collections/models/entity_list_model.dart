import 'package:metamorphis/src/domain/collections/entities/entity_list.dart';
import 'package:metamorphis/src/domain/entity/entities/entity.dart';

class EntityListModel extends EntityList {
  EntityListModel({
    required super.id,
    required super.name,
    required super.entity,
  });

  factory EntityListModel.fromEntity(EntityList entityList) {
    return EntityListModel(
      id: entityList.id,
      name: entityList.name,
      entity: entityList.entity,
    );
  }

  factory EntityListModel.fromMap(Map<String, dynamic> json) {
    return EntityListModel(
      id: json['id'],
      name: json['name'],
      entity: Entity(
        id: json['entityId'],
        name: json['entityName'],
        boundedContextId: '',
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': super.id,
      'name': super.name,
      'entityId': super.entity.id,
      'entityName': super.entity.name,
    };
  }
}
