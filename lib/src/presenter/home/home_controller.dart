import 'dart:developer';
import 'dart:html' as html;

import 'package:archive/archive.dart';
import 'package:change_case/change_case.dart';
import 'package:flutter/material.dart';
import 'package:metamorphis/src/application/entity/delete_entity_use_case.dart';
import 'package:metamorphis/src/application/entity/get_entities_by_application_use_case.dart';
import 'package:metamorphis/src/application/entity/save_entity_use_case.dart';
import 'package:metamorphis/src/application/entity/update_entity_use_case.dart';
import 'package:metamorphis/src/domain/application/entities/api_type.dart';
import 'package:metamorphis/src/domain/application/entities/application.dart';
import 'package:metamorphis/src/domain/entity/entities/entity.dart';
import 'package:metamorphis/src/infrastructure/code_generators/code_generators.dart';
import 'package:metamorphis/src/presenter/_core/app_store.dart';
import 'package:metamorphis/src/presenter/_core/view_models/entity_view_model.dart';

import 'home_store.dart';

class HomeController {
  final HomeStore homeStore;
  final AppStore appStore;
  final pageController = PageController();

  final GetEntitiesByApplicationUseCase getEntitiesByApplicationUseCase;
  final SaveEntityUseCase saveEntityUseCase;
  final UpdateEntityUseCase updateEntityUseCase;
  final DeleteEntityUseCase deleteEntityUseCase;

  HomeController({
    required this.appStore,
    required this.homeStore,
    required this.getEntitiesByApplicationUseCase,
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
    final result = await getEntitiesByApplicationUseCase.execute(
      appStore.application!,
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

  void selectEntity({required Entity? entity}) {
    if (entity == null) {
      appStore.entity = null;
      return;
    }
    appStore.entity = EntityViewModel.fromEntity(entity);
    homeStore.page = 0;
    if (pageController.hasClients) {
      pageController.jumpToPage(0);
    }
  }

  Future<void> saveEntity({required String name}) async {
    final entity = Entity(name: name, applicationId: appStore.application!.id);
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

  Future<void> updateEntity({required Entity entity}) async {
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

  Future<void> deleteEntity({required Entity entity}) async {
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

  void _buildCode(GeneratorTarget target) {
    _loadBoundedContexts(target);
  }

  Future<void> _loadBoundedContexts(GeneratorTarget target) async {
    homeStore.generating = true;
    final application = appStore.application!;
    _generateCode(application, target);
  }

  void _generateCode(Application application, GeneratorTarget target) {
    final name = ChangeCase(application.name).toSnakeCase();
    final archive = CodeGenerators.generateCode(
      application: application,
      target: target,
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

  void buildFlutterWidthSupabase({
    required String supabaseUrlProd,
    required String anonKeyProd,
    required String supabaseUrlDev,
    required String anonKeyDev,
    required GeneratorTarget target,
  }) {
    final application = appStore.application;
    if (application == null) {
      return;
    }
    final apiOptions = ApiOptions(
      apiType: ApiType.supabase,
      prodUrl: supabaseUrlProd,
      prodKey: anonKeyProd,
      devUrl: supabaseUrlDev,
      devKey: anonKeyDev,
    );
    application.apiOptions = apiOptions;
    _buildCode(target);
  }

  void buildGolang() {
    _buildCode(GeneratorTarget.golang);
  }
}
