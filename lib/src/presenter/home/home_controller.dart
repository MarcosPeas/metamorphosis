import 'dart:developer';
import 'dart:html' as html;

import 'package:archive/archive.dart';
import 'package:change_case/change_case.dart';
import 'package:flutter/material.dart';
import 'package:metamorphis/src/application/bounded_context/get_bounded_contexts_by_application_use_case.dart';
import 'package:metamorphis/src/application/entity/delete_entity_use_case.dart';
import 'package:metamorphis/src/application/entity/get_entities_by_bounded_context_use_case.dart';
import 'package:metamorphis/src/application/entity/save_entity_use_case.dart';
import 'package:metamorphis/src/application/entity/update_entity_use_case.dart';
import 'package:metamorphis/src/domain/application/entities/application.dart';
import 'package:metamorphis/src/domain/bounded_context/entities/bounded_context.dart';
import 'package:metamorphis/src/domain/entity/entities/entity.dart';
import 'package:metamorphis/src/infrastructure/code_generators/code_generators.dart';
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
  final GetBoundedContextsByApplicationUseCase
      getBoundedContextsByApplicationUseCase;

  HomeController({
    required this.appStore,
    required this.homeStore,
    required this.getEntitiesByBoundedContextUseCase,
    required this.saveEntityUseCase,
    required this.updateEntityUseCase,
    required this.deleteEntityUseCase,
    required this.getBoundedContextsByApplicationUseCase,
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

  void generateCode() {
    _loadBoundedContexts();
  }

  Future<void> _loadBoundedContexts() async {
    homeStore.generating = true;
    final result = await getBoundedContextsByApplicationUseCase.execute(
      appStore.application!,
    );
    result.fold(
      (error) {
        homeStore.error = error;
        homeStore.generating = false;
      },
      (boundedContexts) async {
        final application = appStore.application!;
        await Future.forEach(boundedContexts, _loadEntities);
        application.contexts = boundedContexts;
        application.project = appStore.project;
        _generateCode(application);
      },
    );
  }

  void _generateCode(Application application) {
    final name = ChangeCase(application.name).toSnakeCase();
    final archive = CodeGenerators.generateCode(
      application: application,
    );
    final zipData = ZipEncoder().encode(archive)!;
    final blob = html.Blob([zipData], 'application/zip');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url);
    anchor.setAttribute('download', '$name.zip');
    anchor.click();
    html.Url.revokeObjectUrl(url);
    homeStore.generating = false;
  }

  Future<void> _loadEntities(BoundedContext boundedContext) async {
    final result = await getEntitiesByBoundedContextUseCase.execute(
      boundedContext,
    );
    result.fold(
      (error) {
        homeStore.error = error;
        homeStore.generating = false;
      },
      (entities) {
        boundedContext.entities = entities;
      },
    );
  }
}
