import 'package:uuid/uuid.dart';

class Project {
  late final String id;
  final String name;
  final String description;
  final DateTime createdAt;
  final String userId;

  Project({
    String? id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.userId,
  }) {
    this.id = id ?? const Uuid().v4();
  }
}
