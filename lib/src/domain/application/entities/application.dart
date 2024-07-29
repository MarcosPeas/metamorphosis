import 'package:uuid/uuid.dart';

class Application {
  late final String id;
  final String name;
  final bool isMicroservice;
  final String projectId;
  final DateTime createdAt;

  Application({
    String? id,
    required this.name,
    required this.isMicroservice,
    required this.projectId,
    required this.createdAt,
  }) {
    {
      this.id = id ?? const Uuid().v4();
    }
  }
}
