import 'dart:developer';

import 'package:metamorphis/src/application/project/delete_project_use_case.dart';
import 'package:metamorphis/src/application/project/get_projects_by_user_use_case.dart';
import 'package:metamorphis/src/application/project/save_project_use_case.dart';
import 'package:metamorphis/src/application/project/update_project_use_case.dart';
import 'package:metamorphis/src/domain/project/entities/project.dart';
import 'package:metamorphis/src/presenter/_core/app_store.dart';

import 'project_store.dart';

class ProjectController {
  final AppStore appStore;
  final ProjectStore store;
  final GetProjectsByUserUseCase getProjectsByUserUseCase;
  final SaveProjectUseCase saveProjectUseCase;
  final UpdateProjectUseCase updateProjectUseCase;
  final DeleteProjectUseCase deleteProjectUseCase;

  ProjectController({
    required this.appStore,
    required this.store,
    required this.getProjectsByUserUseCase,
    required this.saveProjectUseCase,
    required this.updateProjectUseCase,
    required this.deleteProjectUseCase,
  });

  Future<void> init() async {
    if (appStore.user == null || store.projects.isNotEmpty) {
      return;
    }
    store.loading = true;
    final result = await getProjectsByUserUseCase.execute(appStore.user!);
    result.fold(
      (error) {
        store.error = error;
      },
      (projects) {
        store.setProjects(projects);
      },
    );
    store.loading = false;
  }

  Future<void> saveProject({
    required String name,
    required String description,
  }) async {
    final project = Project(
      name: name,
      description: description,
      userId: appStore.user!.id,
    );
    final result = await saveProjectUseCase.execute(project);
    result.fold(
      (error) {
        log(error.message);
        store.error = error;
      },
      (project) {
        log('Project saved: ${project.id}');
        store.addProject(project);
      },
    );
  }

  Future<void> updateProject({
    required Project project,
  }) async {
    final result = await updateProjectUseCase.execute(project);
    result.fold(
      (error) {
        log(error.message);
        store.error = error;
      },
      (project) {
        log('Project updated: ${project.id}');
        store.updateProject(project);
      },
    );
  }

  Future<void> deleteProject({
    required Project project,
  }) async {
    final result = await deleteProjectUseCase.execute(project);
    result.fold(
      (error) {
        log(error.message);
        store.error = error;
      },
      (_) {
        log('Project deleted: ${project.id}');
        store.deleteProject(project);
      },
    );
  }
}
