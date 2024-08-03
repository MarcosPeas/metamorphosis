import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:metamorphis/src/application/project/delete_project_use_case.dart';
import 'package:metamorphis/src/application/project/get_projects_by_user_use_case.dart';
import 'package:metamorphis/src/application/project/save_project_use_case.dart';
import 'package:metamorphis/src/application/project/update_project_use_case.dart';
import 'package:metamorphis/src/domain/project/entities/project.dart';
import 'package:metamorphis/src/presenter/_core/app_store.dart';
import 'package:metamorphis/src/presenter/_core/view_models/project_view_model.dart';
import 'package:metamorphis/src/presenter/application/application_routers.dart';

import 'project_store.dart';

class ProjectController {
  final AppStore appStore;
  final ProjectStore projectStore;
  final GetProjectsByUserUseCase getProjectsByUserUseCase;
  final SaveProjectUseCase saveProjectUseCase;
  final UpdateProjectUseCase updateProjectUseCase;
  final DeleteProjectUseCase deleteProjectUseCase;

  ProjectController({
    required this.appStore,
    required this.projectStore,
    required this.getProjectsByUserUseCase,
    required this.saveProjectUseCase,
    required this.updateProjectUseCase,
    required this.deleteProjectUseCase,
  });

  Future<void> init() async {
    if (appStore.user == null || projectStore.projects.isNotEmpty) {
      return;
    }
    projectStore.loading = true;
    final result = await getProjectsByUserUseCase.execute(appStore.user!);
    result.fold(
      (error) {
        projectStore.error = error;
      },
      (projects) {
        projectStore.setProjects(projects);
      },
    );
    projectStore.loading = false;
  }

  void selectProject({
    required Project project,
    required BuildContext context,
  }) {
    appStore.project = ProjectViewModel.fromEntity(project);
    context.pushNamed(ApplicationRouters.applications);
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
        projectStore.error = error;
      },
      (project) {
        log('Project saved: ${project.id}');
        projectStore.addProject(project);
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
        projectStore.error = error;
      },
      (project) {
        log('Project updated: ${project.id}');
        projectStore.updateProject(project);
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
        projectStore.error = error;
      },
      (_) {
        log('Project deleted: ${project.id}');
        projectStore.deleteProject(project);
      },
    );
  }
}
