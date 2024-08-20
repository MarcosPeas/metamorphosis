import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:metamorphis/src/application/user/get_user_by_id_use_case.dart';
import 'package:metamorphis/src/application/user/sign_in_with_email_and_password_use_case.dart';
import 'package:metamorphis/src/presenter/_core/app_store.dart';
import 'package:metamorphis/src/presenter/login/login_store.dart';
import 'package:metamorphis/src/presenter/project/project_routers.dart';

class LoginController {
  final LoginStore store;
  final AppStore appStore;
  final SignInWithEmailAndPasswordUseCase signInWithEmailAndPasswordUseCase;
  final GetUserByIdUseCase getUserByIdUseCase;

  LoginController({
    required this.store,
    required this.appStore,
    required this.signInWithEmailAndPasswordUseCase,
    required this.getUserByIdUseCase,
  });

  void init(BuildContext context) {
    store.loading = false;
    if (appStore.user != null) {
      context.pushReplacementNamed(ProjectRouters.projects);
    }
  }

  void togglePasswordVisibility() {
    store.togglePasswordVisibility();
  }

  void validateLoginButton(String email, String password) {
    store.validateLoginButton(email, password);
  }

  Future<void> login({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    if (store.loading) {
      return;
    }
    store.loading = true;
    final result = await signInWithEmailAndPasswordUseCase.execute(
      email: email,
      password: password,
    );
    result.fold(
      (error) {
        log(error.message);
        store.error = error;
        store.loading = false;
      },
      (user) async {
        await _loadCurrentUser(context: context, userId: user.id);
        store.loading = false;
      },
    );
  }

  Future<void> _loadCurrentUser({
    required BuildContext context,
    required String userId,
  }) async {
    final result = await getUserByIdUseCase.execute(userId);
    result.fold(
      (error) {
        log(error.message);
      },
      (user) {
        appStore.user = user;
        context.pushReplacementNamed(ProjectRouters.projects);
      },
    );
  }
}
