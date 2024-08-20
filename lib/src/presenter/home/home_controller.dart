import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:metamorphis/src/application/entity/delete_entity_use_case.dart';
import 'package:metamorphis/src/application/entity/get_entities_by_bounded_context_use_case.dart';
import 'package:metamorphis/src/application/entity/save_entity_use_case.dart';
import 'package:metamorphis/src/application/entity/update_entity_use_case.dart';
import 'package:metamorphis/src/domain/entity/entities/entity.dart';
import 'package:metamorphis/src/presenter/_core/app_store.dart';
import 'package:metamorphis/src/presenter/_core/view_models/entity_view_model.dart';

import 'home_store.dart';

class HomeController {
  final HomeStore homeStore;
  final AppStore appStore;
  final pageController = PageController();

  final GetEntitiesByBoundedContextUseCase getEntitiesByBoundedContextUseCase;
  final SaveEntityUseCase saveEntityUseCase;
  final UpdateEntityUseCase updateEntityUseCase;
  final DeleteEntityUseCase deleteEntityUseCase;

  HomeController({
    required this.appStore,
    required this.homeStore,
    required this.getEntitiesByBoundedContextUseCase,
    required this.saveEntityUseCase,
    required this.updateEntityUseCase,
    required this.deleteEntityUseCase,
  });

  Future<void> init() async {
    homeStore.clear();
    if (appStore.project == null) {
      return;
    }
    homeStore.loading = true;
    final result = await getEntitiesByBoundedContextUseCase.execute(
      appStore.boundedContext!,
    );
    result.fold(
      (error) {
        homeStore.error = error;
      },
      (entities) {
        homeStore.setEntities(entities);
        if (entities.isNotEmpty) {
          appStore.entity = EntityViewModel.fromEntity(entities.first);
        }
      },
    );
    homeStore.loading = false;
  }

  void selectEntity({
    required Entity? entity,
  }) {
    if (entity == null) {
      appStore.entity = null;
      return;
    }
    homeStore.page = 0;
    pageController.jumpToPage(0);
    appStore.entity = EntityViewModel.fromEntity(
      entity,
    );
  }

  Future<void> saveEntity({
    required String name,
  }) async {
    final entity = Entity(
      name: name,
      boundedContextId: appStore.boundedContext!.id,
    );
    final result = await saveEntityUseCase.execute(entity);
    result.fold(
      (error) {
        log(error.message);
        log(error.trace);
        homeStore.error = error;
      },
      (entity) {
        homeStore.addEntity(entity);
        selectEntity(entity: entity);
      },
    );
  }

  Future<void> updateEntity({
    required Entity entity,
  }) async {
    final result = await updateEntityUseCase.execute(entity);
    result.fold(
      (error) {
        log(error.message);
        log(error.trace);
        homeStore.error = error;
      },
      (entity) {
        homeStore.updateEntity(entity);
        selectEntity(entity: entity);
      },
    );
  }

  Future<void> deleteEntity({
    required Entity entity,
  }) async {
    final result = await deleteEntityUseCase.execute(entity);
    result.fold(
      (error) {
        log(error.message);
        log(error.trace);
        homeStore.error = error;
      },
      (_) {
        homeStore.deleteEntity(entity);
        selectEntity(entity: homeStore.entities.firstOrNull);
      },
    );
  }
}
