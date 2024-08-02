import 'package:go_router/go_router.dart';

import 'project_page.dart';

class ProjectRouters {
  static const String projects = '/projects';

  static GoRoute route = GoRoute(
    path: projects,
    name: projects,
    builder: (context, state) {
      return const ProjectPage();
    },
  );
}
