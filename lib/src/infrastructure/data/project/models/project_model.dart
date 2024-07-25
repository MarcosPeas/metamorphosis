import 'package:metamorphis/src/domain/project/entities/project.dart';

class ProjectModel extends Project {
  ProjectModel({
    required super.id,
    required super.name,
    required super.description,
    required super.createdAt,
    required super.userId,
  });

  factory ProjectModel.fromEntity(Project project) {
    return ProjectModel(
      id: project.id,
      name: project.name,
      description: project.description,
      createdAt: project.createdAt,
      userId: project.userId,
    );
  }

  factory ProjectModel.fromMap(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': super.id,
      'name': super.name,
      'description': super.description,
      'createdAt': super.createdAt.toIso8601String(),
      'userId': super.userId,
    };
  }
}
