import 'package:get_it/get_it.dart';
import 'package:metamorphis/src/application/user/get_current_user_use_case.dart';
import 'package:metamorphis/src/application/user/sign_in_with_email_and_password_use_case.dart';
import 'package:metamorphis/src/application/user/sign_out_use_case.dart';
import 'package:metamorphis/src/domain/user/repositories/user_repository.dart';
import 'package:metamorphis/src/infrastructure/data/user/repositories/user_repository_firebase_impl.dart';
import 'package:metamorphis/src/presenter/login/login_controller.dart';

import 'login_store.dart';

class LoginInjector {
  static void setup() {
    _setupStores();
    _setupRepositories();
    _setupUseCases();
    _setupControllers();
  }

  static _setupRepositories() {
    final getIt = GetIt.instance;
    getIt.registerFactory<UserRepository>(
      () => UserRepositoryFirebaseImpl(),
    );
  }

  static _setupStores() {
    final getIt = GetIt.instance;
    getIt.registerSingleton(LoginStore());
  }

  static void _setupUseCases() {
    final getIt = GetIt.instance;
    getIt.registerFactory(
      () => SignInWithEmailAndPasswordUseCase(
        userRepository: getIt.get(),
      ),
    );
    getIt.registerFactory(
      () => SignOutUseCase(
        userRepository: getIt.get(),
      ),
    );
    getIt.registerFactory(
      () => GetCurrentUserUseCase(
        userRepository: getIt.get(),
      ),
    );
  }

  static void _setupControllers() {
    final getIt = GetIt.instance;
    getIt.registerFactory<LoginController>(
      () => LoginController(
        store: getIt(),
        appStore: getIt(),
        signInWithEmailAndPasswordUseCase: getIt(),
        getUserByIdUseCase: getIt(),
      ),
    );
  }
}
