import 'dart:developer';

import 'package:flashy_flushbar/flashy_flushbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:metamorphis/src/application/application/delete_application_use_case.dart';
import 'package:metamorphis/src/application/application/get_applications_by_project_use_case.dart';
import 'package:metamorphis/src/application/application/save_application_use_case.dart';
import 'package:metamorphis/src/application/application/update_application_use_case.dart';
import 'package:metamorphis/src/domain/_core/domain/repository.dart';
import 'package:metamorphis/src/domain/application/entities/api_type.dart';
import 'package:metamorphis/src/domain/application/entities/application.dart';
import 'package:metamorphis/src/presenter/_core/app_store.dart';
import 'package:metamorphis/src/presenter/_core/view_models/application_view_model.dart';
import 'package:metamorphis/src/presenter/application/application_store.dart';
import 'package:metamorphis/src/presenter/home/_core/home_routers.dart';

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
      PaginateParams(filterBy: 'projectId', filterValue: appStore.project!.id),
    );
    result.fold(
      (error) {
        applicationStore.error = error;
      },
      (applications) {
        applicationStore.setApplications(applications);
      },
    );
    applicationStore.loading = false;
  }

  void selectApplication({
    required Application application,
    required BuildContext context,
  }) {
    appStore.application = ApplicationViewModel.fromEntity(application);
    context.pushReplacementNamed(HomeRouters.home);
  }

  Future<void> saveApplication({
    required String name,
    required String description,
  }) async {
    final apps = applicationStore.applications;
    final hasAnyWithName = apps.any((app) {
      return app.name.toLowerCase() == name.toLowerCase();
    });
    if (hasAnyWithName) {
      _showDuplicatedErrorMessage();
      return;
    }
    final application = Application(
      name: name,
      description: description,
      isMicroservice: false,
      projectId: appStore.project!.id,
      apiOptions: ApiOptions.empty(),
    );
    final result = await saveApplicationUseCase.execute(application);
    result.fold(
      (error) {
        log(error.toString());
        applicationStore.error = error;
      },
      (application) {
        applicationStore.addApplication(application);
      },
    );
  }

  Future<void> updateApplication({required Application application}) async {
    final apps = [...applicationStore.applications];
    apps.removeWhere((app) {
      return app.id == application.id;
    });
    final hasAnyWithName = apps.any((app) {
      return app.name.toLowerCase() == application.name.toLowerCase();
    });
    if (hasAnyWithName) {
      _showDuplicatedErrorMessage();
      return;
    }
    final result = await updateApplicationUseCase.execute(application);
    result.fold(
      (error) {
        log(error.toString());
        applicationStore.error = error;
      },
      (application) {
        applicationStore.updateApplication(application);
      },
    );
  }

  Future<void> deleteApplication({required Application application}) async {
    final result = await deleteApplicationUseCase.execute(application);
    result.fold(
      (error) {
        log(error.toString());
        applicationStore.error = error;
      },
      (_) {
        applicationStore.deleteApplication(application);
      },
    );
  }
  void _showDuplicatedErrorMessage() {
    FlashyFlushbar(
      leadingWidget: const Icon(
        Icons.error,
        color: Colors.deepOrange,
        size: 24,
      ),
      message: 'An item with that name already exists',
      duration: const Duration(seconds: 5),
      trailingWidget: IconButton(
        icon: const Icon(Icons.close, color: Colors.black, size: 24),
        onPressed: () {
          FlashyFlushbar.cancel();
        },
      ),
      isDismissible: false,
    ).show();
  }
}
