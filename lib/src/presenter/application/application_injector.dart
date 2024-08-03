import 'package:get_it/get_it.dart';
import 'package:metamorphis/src/application/application/delete_application_use_case.dart';
import 'package:metamorphis/src/application/application/get_applications_by_project_use_case.dart';
import 'package:metamorphis/src/application/application/save_application_use_case.dart';
import 'package:metamorphis/src/application/application/update_application_use_case.dart';
import 'package:metamorphis/src/domain/application/repositories/application_repository.dart';
import 'package:metamorphis/src/infrastructure/data/application/repositories/application_repository_impl.dart';

import 'application_controller.dart';
import 'application_store.dart';

class ApplicationInjector {
  static void setup() {
    final getIt = GetIt.instance;
    getIt.registerSingleton(ApplicationStore());
    getIt.registerFactory<ApplicationRepository>(
      () => ApplicationRepositoryImpl(),
    );
    getIt.registerFactory<GetApplicationsByProjectUseCase>(
      () => GetApplicationsByProjectUseCase(
        applicationRepository: getIt(),
      ),
    );
    getIt.registerFactory<SaveApplicationUseCase>(
      () => SaveApplicationUseCase(
        applicationRepository: getIt(),
      ),
    );
    getIt.registerFactory<UpdateApplicationUseCase>(
      () => UpdateApplicationUseCase(
        applicationRepository: getIt(),
      ),
    );
    getIt.registerFactory<DeleteApplicationUseCase>(
      () => DeleteApplicationUseCase(
        applicationRepository: getIt(),
      ),
    );
    getIt.registerFactory<ApplicationController>(
      () => ApplicationController(
        appStore: getIt(),
        applicationStore: getIt(),
        deleteApplicationUseCase: getIt(),
        getApplicationsByProjectUseCase: getIt(),
        saveApplicationUseCase: getIt(),
        updateApplicationUseCase: getIt(),
      ),
    );
  }
}
