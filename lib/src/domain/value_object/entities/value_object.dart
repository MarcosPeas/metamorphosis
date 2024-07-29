import 'package:uuid/uuid.dart';

class ValueObject {
  late final String id;
  final String name;
  final String type;
  final bool nullable;
  final String entityId;

  ValueObject({
    String? id,
    required this.name,
    required this.type,
    required this.nullable,
    required this.entityId,
  }) {
    {
      this.id = id ?? const Uuid().v4();
    }
  }
}
