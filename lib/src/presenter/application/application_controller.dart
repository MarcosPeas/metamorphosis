import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:metamorphis/src/application/application/delete_application_use_case.dart';
import 'package:metamorphis/src/application/application/get_applications_by_project_use_case.dart';
import 'package:metamorphis/src/application/application/save_application_use_case.dart';
import 'package:metamorphis/src/application/application/update_application_use_case.dart';
import 'package:metamorphis/src/domain/application/entities/application.dart';
import 'package:metamorphis/src/presenter/_core/app_store.dart';
import 'package:metamorphis/src/presenter/_core/view_models/application_view_model.dart';
import 'package:metamorphis/src/presenter/application/application_store.dart';
import 'package:metamorphis/src/presenter/bounded_context/bounded_context_routers.dart';

class ApplicationController {
  final AppStore appStore;
  final ApplicationStore applicationStore;

  final GetApplicationsByProjectUseCase getApplicationsByProjectUseCase;
  final SaveApplicationUseCase saveApplicationUseCase;
  final UpdateApplicationUseCase updateApplicationUseCase;
  final DeleteApplicationUseCase deleteApplicationUseCase;

  ApplicationController({
    required this.appStore,
    required this.applicationStore,
    required this.getApplicationsByProjectUseCase,
    required this.saveApplicationUseCase,
    required this.updateApplicationUseCase,
    required this.deleteApplicationUseCase,
  });

  Future<void> init() async {
    applicationStore.clear();
    if (appStore.project == null) {
      return;
    }
    applicationStore.loading = true;
    final result = await getApplicationsByProjectUseCase.execute(
      appStore.project!,
    );
    result.fold(
      (error) {
        applicationStore.error = error;
      },
      (applications) {
        log(applications.length.toString());
        applicationStore.setApplications(applications);
      },
    );
    applicationStore.loading = false;
  }

  void selectApplication({
    required Application application,
    required BuildContext context,
  }) {
    appStore.project!.application = ApplicationViewModel.fromEntity(
      application,
    );
    context.pushNamed(BoundedContextRouters.boundedContexts);
  }

  Future<void> saveApplication({
    required String name,
    required String description,
  }) async {
    final application = Application(
      name: name,
      description: description,
      isMicroservice: false,
      projectId: appStore.project!.id,
    );
    final result = await saveApplicationUseCase.execute(application);
    result.fold(
      (error) {
        log(error.message);
        applicationStore.error = error;
      },
      (application) {
        log('Application saved: ${application.id}');
        applicationStore.addApplication(application);
      },
    );
  }

  Future<void> updateApplication({
    required Application application,
  }) async {
    final result = await updateApplicationUseCase.execute(application);
    result.fold(
      (error) {
        log(error.message);
        applicationStore.error = error;
      },
      (application) {
        log('Application updated: ${application.id}');
        applicationStore.updateApplication(application);
      },
    );
  }

  Future<void> deleteApplication({
    required Application application,
  }) async {
    final result = await deleteApplicationUseCase.execute(application);
    result.fold(
      (error) {
        log(error.message);
        applicationStore.error = error;
      },
      (_) {
        log('Application deleted: ${application.id}');
        applicationStore.deleteApplication(application);
      },
    );
  }
}
