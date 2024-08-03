import 'package:get_it/get_it.dart';
import 'package:metamorphis/src/application/bounded_context/delete_bounded_context_use_case.dart';
import 'package:metamorphis/src/application/bounded_context/get_bounded_contexts_by_application_use_case.dart';
import 'package:metamorphis/src/application/bounded_context/save_bounded_context_use_case.dart';
import 'package:metamorphis/src/application/bounded_context/update_bounded_context_use_case.dart';
import 'package:metamorphis/src/domain/bounded_context/repositories/bounded_context_repository.dart';
import 'package:metamorphis/src/infrastructure/data/bounded_context/repositories/bounded_context_repository_impl.dart';

import 'bounded_context_controller.dart';
import 'bounded_context_store.dart';

class BoundedContextInjector {
  static void setup() {
    final getIt = GetIt.instance;
    getIt.registerSingleton(BoundedContextStore());
    getIt.registerFactory<BoundedContextRepository>(
      () => BoundedContextRepositoryImpl(),
    );
    getIt.registerFactory<GetBoundedContextsByApplicationUseCase>(
      () => GetBoundedContextsByApplicationUseCase(
        boundedContextRepository: getIt(),
      ),
    );
    getIt.registerFactory<SaveBoundedContextUseCase>(
      () => SaveBoundedContextUseCase(
        boundedContextRepository: getIt(),
      ),
    );
    getIt.registerFactory<UpdateBoundedContextUseCase>(
      () => UpdateBoundedContextUseCase(
        boundedContextRepository: getIt(),
      ),
    );
    getIt.registerFactory<DeleteBoundedContextUseCase>(
      () => DeleteBoundedContextUseCase(
        boundedContextRepository: getIt(),
      ),
    );
    getIt.registerFactory<BoundedContextController>(
      () => BoundedContextController(
        boundedContextStore: getIt(),
        saveBoundedContextUseCase: getIt(),
        updateBoundedContextUseCase: getIt(),
        deleteBoundedContextUseCase: getIt(),
        appStore: getIt(),
        getBoundedContextsByApplicationUseCase: getIt(),
      ),
    );
  }
}
