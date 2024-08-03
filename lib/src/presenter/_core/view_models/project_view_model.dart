import 'package:metamorphis/src/domain/project/entities/project.dart';

import 'application_view_model.dart';

class ProjectViewModel extends Project {
  ApplicationViewModel? application;

  ProjectViewModel({
    required super.id,
    required super.name,
    required super.description,
    required super.userId,
  });

  factory ProjectViewModel.fromEntity(Project project) {
    return ProjectViewModel(
      id: project.id,
      name: project.name,
      description: project.description,
      userId: project.userId,
    );
  }
}
