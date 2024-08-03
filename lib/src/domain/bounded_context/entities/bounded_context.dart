import 'package:uuid/uuid.dart';

class BoundedContext {
  late final String id;
  String name;
  bool enabled;
  final String applicationId;
  late final DateTime createdAt;

  BoundedContext({
    String? id,
    required this.name,
    required this.enabled,
    required this.applicationId,
    DateTime? createdAt,
  }) {
    {
      this.id = id ?? const Uuid().v4();
      this.createdAt = createdAt ?? DateTime.now();
    }
  }
}
