import 'dart:developer';

import 'package:metamorphis/src/application/user/get_user_by_id_use_case.dart';
import 'package:metamorphis/src/application/user/sign_in_with_email_and_password_use_case.dart';
import 'package:metamorphis/src/presenter/_core/app_store.dart';
import 'package:metamorphis/src/presenter/login/login_store.dart';

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

  void togglePasswordVisibility() {
    store.togglePasswordVisibility();
  }

  void validateLoginButton(String email, String password) {
    store.validateLoginButton(email, password);
  }

  void setLoading(bool value) {
    store.setLoading(value);
  }

  Future<void> login(String email, String password) async {
    setLoading(true);
    final result = await signInWithEmailAndPasswordUseCase.execute(
      email: email,
      password: password,
    );
    result.fold(
      (error) {
        log(error.message);
      },
      (user) {
        _loadCurrentUser(user.id);
      },
    );
  }

  Future<void> _loadCurrentUser(String userId) async {
    final result = await getUserByIdUseCase.execute(userId);
    result.fold(
      (error) {
        log(error.message);
      },
      (user) {
        log('usuário logado: ${user.email}');
      },
    );
    setLoading(false);
  }
}
