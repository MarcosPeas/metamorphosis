import 'package:metamorphis/src/domain/value_object/entities/value_object.dart';

class ValueObjectModel extends ValueObject {
  ValueObjectModel({
    required super.id,
    required super.name,
    required super.type,
    required super.nullable,
    required super.entityId,
  });

  factory ValueObjectModel.fromValueObject(ValueObject valueObject) {
    return ValueObjectModel(
      id: valueObject.id,
      name: valueObject.name,
      type: valueObject.type,
      nullable: valueObject.nullable,
      entityId: valueObject.entityId,
    );
  }

  factory ValueObjectModel.fromMap(Map<String, dynamic> json) {
    return ValueObjectModel(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      nullable: json['nullable'],
      entityId: json['entityId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'nullable': nullable,
      'entityId': entityId,
    };
  }
}
