import 'package:metamorphis/src/domain/bounded_context/entities/bounded_context.dart';
import 'package:metamorphis/src/domain/project/entities/project.dart';
import 'package:uuid/uuid.dart';

class Application {
  late final String id;
  String name;
  String description;
  bool isMicroservice;
  String projectId;
  late final DateTime createdAt;
  Project? project;
  List<BoundedContext> contexts = [];


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
