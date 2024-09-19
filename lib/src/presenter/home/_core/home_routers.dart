import 'package:go_router/go_router.dart';

import '../home_page.dart';

class HomeRouters {
  static const String home = '/home';

  static GoRoute route = GoRoute(
    path: home,
    name: home,
    builder: (context, state) {
      return const HomePage();
    },
  );
}
