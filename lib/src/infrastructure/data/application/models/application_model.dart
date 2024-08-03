import 'package:metamorphis/src/domain/application/entities/application.dart';

class ApplicationModel extends Application {
  ApplicationModel({
    required super.id,
    required super.name,
    required super.description,
    required super.createdAt,
    required super.isMicroservice,
    required super.projectId,
  });

  factory ApplicationModel.fromEntity(Application application) {
    return ApplicationModel(
      id: application.id,
      name: application.name,
      description: application.description,
      isMicroservice: application.isMicroservice,
      projectId: application.projectId,
      createdAt: application.createdAt,
    );
  }

  factory ApplicationModel.fromMap(Map<String, dynamic> json) {
    return ApplicationModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      isMicroservice: json['isMicroservice'],
      projectId: json['projectId'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': super.id,
      'name': super.name,
      'description': super.description,
      'isMicroservice': super.isMicroservice,
      'projectId': super.projectId,
      'createdAt': super.createdAt.toIso8601String(),
    };
  }
}
