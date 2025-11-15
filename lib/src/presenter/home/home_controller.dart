import 'dart:developer';
import 'dart:html' as html;

import 'package:archive/archive.dart';
import 'package:change_case/change_case.dart';
import 'package:flashy_flushbar/flashy_flushbar.dart';
import 'package:flutter/material.dart';
import 'package:metamorphis/src/application/application/update_application_use_case.dart';
import 'package:metamorphis/src/application/entity/delete_entity_use_case.dart';
import 'package:metamorphis/src/application/entity/get_entities_by_application_use_case.dart';
import 'package:metamorphis/src/application/entity/save_entity_use_case.dart';
import 'package:metamorphis/src/application/entity/update_entities_use_case.dart';
import 'package:metamorphis/src/application/entity/update_entity_use_case.dart';
import 'package:metamorphis/src/application/global_enumerator/get_global_enumerators_by_application_use_case.dart';
import 'package:metamorphis/src/domain/_core/domain/repository.dart';
import 'package:metamorphis/src/domain/application/entities/api_type.dart';
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
  final UpdateEntitiesUseCase updateEntitiesUseCase;
  final DeleteEntityUseCase deleteEntityUseCase;
  final GetGlobalEnumeratorsByApplicationUseCase
  getGlobalEnumeratorsByApplicationUseCase;
  final UpdateApplicationUseCase updateApplicationUseCase;

  HomeController({
    required this.appStore,
    required this.homeStore,
    required this.getEntitiesByApplicationUseCase,
    required this.saveEntityUseCase,
    required this.updateEntityUseCase,
    required this.deleteEntityUseCase,
    required this.getGlobalEnumeratorsByApplicationUseCase,
    required this.updateEntitiesUseCase,
    required this.updateApplicationUseCase,
  });

  Future<void> init() async {
    homeStore.loading = true;
    homeStore.clear();
    if (appStore.project == null) {
      return;
    }
    await loadEnumerators();
    await loadEntities();
    homeStore.loading = false;
  }

  Future<void> loadEntities() async {
    final result = await getEntitiesByApplicationUseCase.execute(
      PaginateParams(
        filterBy: 'applicationId',
        filterValue: appStore.application!.id,
      ),
    );
    result.fold(
      (error) {
        homeStore.error = error;
      },
      (entities) {
        homeStore.entities = entities;
        appStore.application?.addAllEntities(entities);
        if (entities.isNotEmpty) {
          appStore.entity = EntityViewModel.fromEntity(entities.first);
        }
      },
    );
  }

  Future<void> loadEnumerators() async {
    final result = await getGlobalEnumeratorsByApplicationUseCase.execute(
      PaginateParams(
        filterBy: 'applicationId',
        filterValue: appStore.application!.id,
      ),
    );
    result.fold(
      (error) {
        log(error.message);
        log(error.trace);
        homeStore.error = error;
      },
      (enumerators) {
        homeStore.enumerators = enumerators;
      },
    );
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
    final entities = homeStore.entities;
    final hasAnyWithName = entities.any((entity) {
      return entity.name.toLowerCase() == name.toLowerCase();
    });
    if (hasAnyWithName) {
      _showDuplicatedErrorMessage('An item with that name already exists');
      return;
    }
    final entity = Entity(
      name: name,
      applicationId: appStore.application!.id,
      version: appStore.application!.version + 1,
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
    required String name,
  }) async {
    entity.changeName(name, appStore.application!.version + 1);
    final entities = [...homeStore.entities];
    entities.removeWhere((item) {
      return item.id == entity.id;
    });
    final hasAnyWithName = entities.any((element) {
      return element.name.toLowerCase() == entity.name.toLowerCase();
    });
    if (hasAnyWithName) {
      _showDuplicatedErrorMessage('An item with that name already exists');
      return;
    }
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

  Future<void> _updateToUsedEntities(GeneratorTarget target) async {
    homeStore.generating = true;
    final entities = appStore.application!.entities;
    for (final entity in entities) {
      entity.changeToUsedInSchemeGeneration();
    }
    final result = await updateEntitiesUseCase.execute(entities);
    result.fold(
      (error) {
        log(error.message);
        log(error.trace);
        _showDuplicatedErrorMessage('Unable to generate the requested project');
      },
      (_) {
        homeStore.entities = entities;
        _buildCode(target);
      },
    );
  }

  Future<void> _updateApplication() async {
    updateApplicationUseCase.execute(appStore.application!);
  }

  Future<void> _buildCode(GeneratorTarget target) async {
    final application = appStore.application!;
    application.incrementVersion();
    application.entities = homeStore.entities;
    final name = ChangeCase(application.name).toSnakeCase();
    final archive = CodeGenerators.generateCode(
      application: application,
      target: target,
      enumerators: homeStore.enumerators,
    );
    final zipData = ZipEncoder().encode(archive);
    final blob = html.Blob([zipData], 'application/zip');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url);
    anchor.setAttribute('download', '$name.zip');
    anchor.click();
    html.Url.revokeObjectUrl(url);
    homeStore.generating = false;
    _updateApplication();
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
    _updateToUsedEntities(target);
  }

  void buildRust() {
    _updateToUsedEntities(GeneratorTarget.rust);
  }

  void _showDuplicatedErrorMessage(String message) {
    FlashyFlushbar(
      leadingWidget: const Icon(
        Icons.error,
        color: Colors.deepOrange,
        size: 24,
      ),
      message: message,
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
