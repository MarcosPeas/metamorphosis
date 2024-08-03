import 'package:go_router/go_router.dart';

import 'application_page.dart';

class ApplicationRouters {
  static const String applications = '/applications';

  static GoRoute route = GoRoute(
    path: applications,
    name: applications,
    builder: (context, state) {
      return const ApplicationPage();
    },
  );
}
