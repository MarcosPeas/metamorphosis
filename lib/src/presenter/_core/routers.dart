import 'package:go_router/go_router.dart';
import 'package:metamorphis/src/presenter/login/login_routers.dart';
import 'package:metamorphis/src/presenter/project/project_routers.dart';
import 'package:metamorphis/src/presenter/splash/splash_injector.dart';
import 'package:metamorphis/src/presenter/splash/splash_page.dart';

class Routers {
  static const String splash = '/';
  static const String login = '/login';

  static final router = GoRouter(
    routes: [
      GoRoute(
        path: splash,
        name: splash,
        builder: (context, state) {
          return const SplashPage();
        },
      ),
      LoginRouters.route,
      ProjectRouters.route,
    ],
  );
}
