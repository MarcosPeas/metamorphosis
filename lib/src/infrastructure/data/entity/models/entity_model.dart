import 'package:metamorphis/src/domain/entity/entities/entity.dart';
import 'package:metamorphis/src/domain/value_object/entities/value_object.dart';
import 'package:metamorphis/src/infrastructure/data/value_object/models/value_object_model.dart';

class EntityModel extends Entity {
  EntityModel({
    required super.id,
    required super.name,
    required super.boundedContextId,
    super.valueObjects,
  });

  factory EntityModel.fromEntity(Entity entity) {
    return EntityModel(
      id: entity.id,
      name: entity.name,
      boundedContextId: entity.boundedContextId,
      valueObjects: entity.valueObjects,
    );
  }

  factory EntityModel.fromMap(Map<String, dynamic> json) {
    final valueObjects = <ValueObject>[];
    if (json['valueObjects'] != null) {
      json['valueObjects'].forEach((valueObject) {
        valueObjects.add(ValueObjectModel.fromMap(valueObject));
      });
    }
    return EntityModel(
      id: json['id'],
      name: json['name'],
      boundedContextId: json['boundedContextId'],
      valueObjects: valueObjects,
    );
  }

  Map<String, dynamic> toJson() {
    final valueObjectsModel = valueObjects.map((valueObject) {
      return ValueObjectModel.fromValueObject(valueObject).toMap();
    }).toList();
    return {
      'id': id,
      'name': name,
      'boundedContextId': boundedContextId,
      'valueObjects': valueObjectsModel,
    };
  }
}
