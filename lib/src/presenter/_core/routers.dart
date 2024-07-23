import 'package:go_router/go_router.dart';
import 'package:metamorphis/src/presenter/splash/splash_page.dart';

class Routers {
  static const String splash = '/';

  static final router = GoRouter(
    routes: [
      GoRoute(
        path: splash,
        builder: (context, state) {
          return const SplashPage();
        },
      ),
    ],
  );
}
