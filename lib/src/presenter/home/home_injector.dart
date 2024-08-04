import 'package:get_it/get_it.dart';
import 'package:metamorphis/src/application/entity/delete_entity_use_case.dart';
import 'package:metamorphis/src/application/entity/get_entities_by_bounded_context_use_case.dart';
import 'package:metamorphis/src/application/entity/save_entity_use_case.dart';
import 'package:metamorphis/src/application/entity/update_entity_use_case.dart';
import 'package:metamorphis/src/domain/entity/repositories/entity_repository.dart';
import 'package:metamorphis/src/infrastructure/data/entity/repositories/entity_repository_impl.dart';
import 'package:metamorphis/src/presenter/home/home_controller.dart';
import 'package:metamorphis/src/presenter/home/home_store.dart';

class HomeInjector {
  static void setup() {
    final getIt = GetIt.instance;
    getIt.registerSingleton(HomeStore());
    getIt.registerFactory<EntityRepository>(
      () => EntityRepositoryImpl(),
    );
    getIt.registerFactory<GetEntitiesByBoundedContextUseCase>(
      () => GetEntitiesByBoundedContextUseCase(
        entityRepository: getIt(),
      ),
    );
    getIt.registerFactory<SaveEntityUseCase>(
      () => SaveEntityUseCase(
        entityRepository: getIt(),
      ),
    );
    getIt.registerFactory<UpdateEntityUseCase>(
      () => UpdateEntityUseCase(
        entityRepository: getIt(),
      ),
    );
    getIt.registerFactory<DeleteEntityUseCase>(
      () => DeleteEntityUseCase(
        entityRepository: getIt(),
      ),
    );
    getIt.registerFactory<HomeController>(
      () => HomeController(
        appStore: getIt(),
        homeStore: getIt(),
        deleteEntityUseCase: getIt(),
        saveEntityUseCase: getIt(),
        updateEntityUseCase: getIt(),
        getEntitiesByBoundedContextUseCase: getIt(),
      ),
    );
  }
}
