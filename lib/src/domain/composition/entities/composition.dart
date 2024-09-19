import 'package:metamorphis/src/domain/entity/entities/entity.dart';
import 'package:uuid/uuid.dart';

class Composition {
  late final String id;
  String name;
  Entity entity;
  CompositionType compositionType;

  Composition({
    String? id,
    required this.name,
    required this.entity,
    required this.compositionType,
  }) {
    this.id = id ?? const Uuid().v4();
  }
}

enum CompositionType {
  singleEntity('singleEntity'),
  listOfEntities('listOfEntities');

  final String name;

  const CompositionType(this.name);

  static CompositionType fromString(String value) {
    switch (value) {
      case 'listOfEntities':
        return listOfEntities;
      case 'singleEntity':
        return singleEntity;
      default:
        return singleEntity;
    }
  }
}
