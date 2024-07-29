import 'package:uuid/uuid.dart';

class BoundedContext {
  late final String id;
  final String name;
  final bool enabled;
  final String applicationId;
  final DateTime createdAt;

  BoundedContext({
    String? id,
    required this.name,
    required this.enabled,
    required this.applicationId,
    required this.createdAt,
  }) {
    {
      this.id = id ?? const Uuid().v4();
    }
  }
}
