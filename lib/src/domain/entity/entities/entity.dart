import 'package:metamorphis/src/domain/value_object/entities/value_object.dart';
import 'package:uuid/uuid.dart';

class Entity {
  late final String id;
  final String name;
  final String boundedContextId;
  late final List<ValueObject> valueObjects;

  Entity({
    String? id,
    required this.name,
    required this.boundedContextId,
    List<ValueObject>? valueObjects,
  }) {
    {
      this.id = id ?? const Uuid().v4();
      this.valueObjects = valueObjects ?? [];
    }
  }
}
