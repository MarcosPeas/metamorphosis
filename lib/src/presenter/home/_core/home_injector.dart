import 'package:get_it/get_it.dart';
import 'package:metamorphis/src/application/entity/delete_entity_use_case.dart';
import 'package:metamorphis/src/application/entity/get_entities_by_bounded_context_use_case.dart';
import 'package:metamorphis/src/application/entity/save_entity_use_case.dart';
import 'package:metamorphis/src/application/entity/update_entity_use_case.dart';
import 'package:metamorphis/src/application/value_object/delete_value_object_use_case.dart';
import 'package:metamorphis/src/application/value_object/get_value_objects_by_entity_use_case.dart';
import 'package:metamorphis/src/application/value_object/save_value_object_use_case.dart';
import 'package:metamorphis/src/application/value_object/update_value_object_use_case.dart';
import 'package:metamorphis/src/domain/entity/repositories/entity_repository.dart';
import 'package:metamorphis/src/domain/value_object/repositories/value_object_repository.dart';
import 'package:metamorphis/src/infrastructure/data/entity/repositories/entity_repository_impl.dart';
import 'package:metamorphis/src/infrastructure/data/value_object/repositories/value_object_repository_impl.dart';
import 'package:metamorphis/src/presenter/home/home_controller.dart';
import 'package:metamorphis/src/presenter/home/home_store.dart';

import '../entity_lists/compositions_controller.dart';
import '../entity_rules/entity_rules_controller.dart';
import '../use_cases/use_cases_controller.dart';
import '../value_objects/value_objects_controller.dart';
import 'entity_store.dart';

class HomeInjector {
  static void setup() {
    _injectStores();
    _injectRepositories();
    _injectUseCases();
    _injectControllers();
  }

  static void _injectStores() {
    final getIt = GetIt.instance;
    getIt.registerSingleton(HomeStore());
    getIt.registerSingleton(EntityStore());
  }

  static void _injectRepositories() {
    final getIt = GetIt.instance;
    getIt.registerFactory<EntityRepository>(() => EntityRepositoryImpl());
    getIt.registerFactory<ValueObjectRepository>(
      () => ValueObjectRepositoryImpl(),
    );
  }

  static void _injectUseCases() {
    final getIt = GetIt.instance;
    getIt.registerFactory<GetEntitiesByBoundedContextUseCase>(
      () => GetEntitiesByBoundedContextUseCase(entityRepository: getIt()),
    );
    getIt.registerFactory<SaveEntityUseCase>(
      () => SaveEntityUseCase(entityRepository: getIt()),
    );
    getIt.registerFactory<UpdateEntityUseCase>(
      () => UpdateEntityUseCase(entityRepository: getIt()),
    );
    getIt.registerFactory<DeleteEntityUseCase>(
      () => DeleteEntityUseCase(entityRepository: getIt()),
    );
    getIt.registerFactory<GetValueObjectsByEntityUseCase>(
      () => GetValueObjectsByEntityUseCase(valueObjectRepository: getIt()),
    );
    getIt.registerFactory<SaveValueObjectUseCase>(
      () => SaveValueObjectUseCase(valueObjectRepository: getIt()),
    );
    getIt.registerFactory<UpdateValueObjectUseCase>(
      () => UpdateValueObjectUseCase(valueObjectRepository: getIt()),
    );
    getIt.registerFactory<DeleteValueObjectUseCase>(
      () => DeleteValueObjectUseCase(valueObjectRepository: getIt()),
    );
  }

  static void _injectControllers() {
    final getIt = GetIt.instance;
    getIt.registerFactory<HomeController>(
      () => HomeController(
        appStore: getIt(),
        homeStore: getIt(),
        deleteEntityUseCase: getIt(),
        saveEntityUseCase: getIt(),
        updateEntityUseCase: getIt(),
        getEntitiesByBoundedContextUseCase: getIt(),
        getBoundedContextsByApplicationUseCase: getIt(),
      ),
    );
    getIt.registerFactory<ValueObjectsController>(
      () => ValueObjectsController(
        entityStore: getIt(),
        updateEntityUseCase: getIt(),
      ),
    );
    getIt.registerFactory<UseCasesController>(
      () => UseCasesController(
        entityStore: getIt(),
        updateEntityUseCase: getIt(),
      ),
    );
    getIt.registerFactory<EntityRulesController>(
      () => EntityRulesController(
        entityStore: getIt(),
        updateEntityUseCase: getIt(),
      ),
    );
    getIt.registerFactory<CompositionsController>(
      () => CompositionsController(
        entityStore: getIt(),
        updateEntityUseCase: getIt(),
      ),
    );
  }
}
