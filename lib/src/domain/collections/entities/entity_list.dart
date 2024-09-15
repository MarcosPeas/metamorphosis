import 'package:metamorphis/src/domain/entity/entities/entity.dart';
import 'package:uuid/uuid.dart';

class EntityList {
  late final String id;
  String name;
  Entity entity;

  EntityList({
    String? id,
    required this.name,
    required this.entity,
  }) {
    this.id = id ?? const Uuid().v4();
  }
}
