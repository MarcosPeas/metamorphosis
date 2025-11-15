import 'package:metamorphis/src/domain/application/entities/application.dart';

class ApplicationViewModel extends Application {
  ApplicationViewModel({
    required super.id,
    required super.name,
    required super.description,
    required super.isMicroservice,
    required super.projectId,
    required super.createdAt,
    required super.apiOptions,
    required super.version,
  });

  factory ApplicationViewModel.fromEntity(Application application) {
    return ApplicationViewModel(
      id: application.id,
      name: application.name,
      description: application.description,
      isMicroservice: application.isMicroservice,
      projectId: application.projectId,
      createdAt: application.createdAt,
      apiOptions: application.apiOptions,
      version: application.version,
    );
  }
}
