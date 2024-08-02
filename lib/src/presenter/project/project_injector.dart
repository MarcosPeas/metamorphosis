import 'package:get_it/get_it.dart';
import 'package:metamorphis/src/application/project/delete_project_use_case.dart';
import 'package:metamorphis/src/application/project/get_projects_by_user_use_case.dart';
import 'package:metamorphis/src/application/project/save_project_use_case.dart';
import 'package:metamorphis/src/application/project/update_project_use_case.dart';
import 'package:metamorphis/src/domain/project/repositories/project_repository.dart';
import 'package:metamorphis/src/infrastructure/data/project/repositories/project_repository_impl.dart';

import 'project_controller.dart';
import 'project_store.dart';

class ProjectInjector {
  static void setup() {
    final getIt = GetIt.instance;
    getIt.registerSingleton(ProjectStore());
    getIt.registerFactory<ProjectRepository>(
      () => ProjectRepositoryImpl(),
    );
    getIt.registerFactory<GetProjectsByUserUseCase>(
      () => GetProjectsByUserUseCase(
        projectRepository: getIt(),
      ),
    );
    getIt.registerFactory<SaveProjectUseCase>(
      () => SaveProjectUseCase(
        projectRepository: getIt(),
      ),
    );
    getIt.registerFactory<UpdateProjectUseCase>(
      () => UpdateProjectUseCase(
        projectRepository: getIt(),
      ),
    );
    getIt.registerFactory<DeleteProjectUseCase>(
      () => DeleteProjectUseCase(
        projectRepository: getIt(),
      ),
    );
    getIt.registerFactory<ProjectController>(
      () => ProjectController(
        store: getIt(),
        getProjectsByUserUseCase: getIt(),
        saveProjectUseCase: getIt(),
        updateProjectUseCase: getIt(),
        deleteProjectUseCase: getIt(),
        appStore: getIt(),
      ),
    );
  }
}
