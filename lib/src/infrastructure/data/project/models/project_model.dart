import 'dart:convert';

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

  factory ProjectModel.fromMap(Map<String, dynamic> map) {
    return ProjectModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      createdAt: DateTime.parse(map['createdAt']),
      userId: map['userId'],
    );
  }

  factory ProjectModel.fromJson(String json) {
    return ProjectModel.fromMap(jsonDecode(json));
  }

  Map<String, dynamic> toMap() {
    return {
      'id': super.id,
      'name': super.name,
      'description': super.description,
      'createdAt': super.createdAt.toIso8601String(),
      'userId': super.userId,
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }
}
