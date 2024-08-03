import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:metamorphis/src/application/bounded_context/delete_bounded_context_use_case.dart';
import 'package:metamorphis/src/application/bounded_context/get_bounded_contexts_by_application_use_case.dart';
import 'package:metamorphis/src/application/bounded_context/save_bounded_context_use_case.dart';
import 'package:metamorphis/src/application/bounded_context/update_bounded_context_use_case.dart';
import 'package:metamorphis/src/domain/bounded_context/entities/bounded_context.dart';
import 'package:metamorphis/src/presenter/_core/app_store.dart';
import 'package:metamorphis/src/presenter/_core/view_models/bounded_context_view_model.dart';

import 'bounded_context_store.dart';

class BoundedContextController {
  final AppStore appStore;
  final BoundedContextStore boundedContextStore;
  final GetBoundedContextsByApplicationUseCase
      getBoundedContextsByApplicationUseCase;
  final SaveBoundedContextUseCase saveBoundedContextUseCase;
  final UpdateBoundedContextUseCase updateBoundedContextUseCase;
  final DeleteBoundedContextUseCase deleteBoundedContextUseCase;

  BoundedContextController({
    required this.appStore,
    required this.boundedContextStore,
    required this.getBoundedContextsByApplicationUseCase,
    required this.saveBoundedContextUseCase,
    required this.updateBoundedContextUseCase,
    required this.deleteBoundedContextUseCase,
  });

  Future<void> init() async {
    boundedContextStore.clear();
    final application = appStore.project?.application;
    if (application == null) {
      return;
    }
    boundedContextStore.loading = true;
    final result = await getBoundedContextsByApplicationUseCase.execute(
      application,
    );
    result.fold(
      (error) {
        boundedContextStore.error = error;
      },
      (boundedContexts) {
        boundedContextStore.setBoundedContexts(boundedContexts);
      },
    );
    boundedContextStore.loading = false;
  }

  void selectBoundedContext({
    required BoundedContext boundedContext,
    required BuildContext context,
  }) {
    appStore.project!.application!.boundedContext =
        BoundedContextViewModel.fromEntity(boundedContext);
    context.pushNamed('home');
  }

  Future<void> saveBoundedContext({
    required String name,
  }) async {
    final boundedContext = BoundedContext(
      name: name,
      enabled: true,
      applicationId: appStore.project!.application!.id,
    );
    final result = await saveBoundedContextUseCase.execute(boundedContext);
    result.fold(
      (error) {
        log(error.message);
        boundedContextStore.error = error;
      },
      (boundedContext) {
        log('BoundedContext saved: ${boundedContext.id}');
        boundedContextStore.addBoundedContext(boundedContext);
      },
    );
  }

  Future<void> updateBoundedContext({
    required BoundedContext boundedContext,
  }) async {
    final result = await updateBoundedContextUseCase.execute(boundedContext);
    result.fold(
      (error) {
        log(error.message);
        boundedContextStore.error = error;
      },
      (boundedContext) {
        log('BoundedContext updated: ${boundedContext.id}');
        boundedContextStore.updateBoundedContext(boundedContext);
      },
    );
  }

  Future<void> deleteBoundedContext({
    required BoundedContext boundedContext,
  }) async {
    final result = await deleteBoundedContextUseCase.execute(boundedContext);
    result.fold(
      (error) {
        log(error.message);
        boundedContextStore.error = error;
      },
      (_) {
        log('BoundedContext deleted: ${boundedContext.id}');
        boundedContextStore.deleteBoundedContext(boundedContext);
      },
    );
  }
}
