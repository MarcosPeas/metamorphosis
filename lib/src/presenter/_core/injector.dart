import 'package:get_it/get_it.dart';
import 'package:metamorphis/src/presenter/application/application_injector.dart';
import 'package:metamorphis/src/presenter/bounded_context/bounded_context_injector.dart';
import 'package:metamorphis/src/presenter/home/_core/home_injector.dart';
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
    ApplicationInjector.setup();
    HomeInjector.setup();
  }

  static void _setupStores() {
    final getIt = GetIt.instance;
    getIt.registerSingleton(AppStore());
  }
}
