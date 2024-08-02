import 'package:uuid/uuid.dart';

class Project {
  late final String id;
  String name;
  String description;
  late final DateTime createdAt;
  final String userId;

  Project({
    String? id,
    required this.name,
    required this.description,
    DateTime? createdAt,
    required this.userId,
  }) {
    this.id = id ?? const Uuid().v4();
    this.createdAt = createdAt ?? DateTime.now();
  }
}
