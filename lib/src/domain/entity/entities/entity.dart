import 'package:uuid/uuid.dart';

class Entity {
  late final String id;
  final String name;
  final String boundedContextId;

  Entity({
    String? id,
    required this.name,
    required this.boundedContextId,
  }) {
    {
      this.id = id ?? const Uuid().v4();
    }
  }
}
