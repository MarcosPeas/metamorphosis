import 'package:flutter/material.dart';

class LoginStore extends ChangeNotifier {
  bool _isPasswordVisible = false;
  bool _isLoginButtonEnabled = false;
  bool _isLoginLoading = false;

  bool get isPasswordVisible => _isPasswordVisible;

  bool get isLoginButtonEnabled => _isLoginButtonEnabled;

  bool get isLoginLoading => _isLoginLoading;

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void validateLoginButton(String email, String password) {
    _isLoginButtonEnabled = email.isNotEmpty && password.isNotEmpty;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoginLoading = value;
    notifyListeners();
  }
}
