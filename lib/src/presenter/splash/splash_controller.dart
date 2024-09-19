import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:metamorphis/src/application/user/get_current_user_use_case.dart';
import 'package:metamorphis/src/presenter/_core/app_store.dart';
import 'package:metamorphis/src/presenter/_core/firebase_options.dart';
import 'package:metamorphis/src/presenter/_core/injector.dart';
import 'package:metamorphis/src/presenter/project/project_routers.dart';

class SplashController {
  late final GetCurrentUserUseCase _getCurrentUserUseCase;

  Future<void> loadDependencies(BuildContext context) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    Injector.setup();
    Future.delayed(const Duration(seconds: 2)).then((_) {
      _getCurrentUserUseCase = GetIt.instance.get<GetCurrentUserUseCase>();
      _validateLoggedUser(context);
    });
  }

  Future<void> _validateLoggedUser(BuildContext context) async {
    final result = await _getCurrentUserUseCase.execute();
    result.fold(
      (l) {
        context.pushReplacementNamed('/login');
      },
      (r) {
        final appStore = GetIt.instance.get<AppStore>();
        appStore.user = r;
        context.pushReplacementNamed(ProjectRouters.projects);
      },
    );
  }
}
