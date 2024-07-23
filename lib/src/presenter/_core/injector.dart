import 'package:get_it/get_it.dart';
import 'package:metamorphis/src/presenter/splash/splash_injector.dart';

class Injector {
  static void setup() {
    final getIt = GetIt.instance;
    SplashInjector.setup(getIt);
  }
}