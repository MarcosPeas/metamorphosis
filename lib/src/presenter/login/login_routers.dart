import 'package:go_router/go_router.dart';

import 'login_page.dart';

class LoginRouters {
  static const String login = '/login';

  static final route = GoRoute(
    path: login,
    name: login,
    builder: (context, state) {
      return const LoginPage();
    },
  );
}
