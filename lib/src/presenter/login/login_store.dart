import 'package:metamorphis/src/presenter/_core/store.dart';

class LoginStore extends Store {
  bool _isPasswordVisible = false;
  bool _isLoginButtonEnabled = false;

  bool get isPasswordVisible => _isPasswordVisible;

  bool get isLoginButtonEnabled => _isLoginButtonEnabled;

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void validateLoginButton(String email, String password) {
    _isLoginButtonEnabled = email.isNotEmpty && password.isNotEmpty;
    notifyListeners();
  }
}
