import 'package:go_router/go_router.dart';

import 'bounded_context_page.dart';

class BoundedContextRouters {
  static const String boundedContexts = '/boundedContexts';

  static GoRoute route = GoRoute(
    path: boundedContexts,
    name: boundedContexts,
    builder: (context, state) {
      return const BoundedContextPage();
    },
  );
}
