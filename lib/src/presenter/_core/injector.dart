import 'package:get_it/get_it.dart';
import 'package:metamorphis/src/presenter/login/login_injector.dart';
import 'package:metamorphis/src/presenter/project/project_injector.dart';
import 'package:metamorphis/src/presenter/splash/splash_injector.dart';

import 'app_store.dart';

class Injector {
  static void setup() {
    _setupStores();
    LoginInjector.setup();
    SplashInjector.setup();
    ProjectInjector.setup();
  }

  static void _setupStores() {
    final getIt = GetIt.instance;
    getIt.registerSingleton(AppStore());
  }
}
