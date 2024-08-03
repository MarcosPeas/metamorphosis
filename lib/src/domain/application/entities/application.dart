import 'package:uuid/uuid.dart';

class Application {
  late final String id;
  String name;
  String description;
  bool isMicroservice;
  String projectId;
  late final DateTime createdAt;


  Application({
    String? id,
    required this.name,
    required this.description,
    required this.isMicroservice,
    required this.projectId,
    DateTime? createdAt,
  }) {
    {
      this.id = id ?? const Uuid().v4();
      this.createdAt = createdAt ?? DateTime.now();
    }
  }
}
