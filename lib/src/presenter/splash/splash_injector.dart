import 'package:get_it/get_it.dart';

import 'splash_controller.dart';

class SplashInjector {
  static void setup(GetIt getIt) {
    _setupControllers(getIt);
  }

  static void _setupControllers(GetIt getIt) {
    getIt.registerFactory<SplashController>(() => SplashController());
  }
}
