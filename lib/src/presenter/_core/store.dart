import 'package:flutter/material.dart';
import 'package:metamorphis/src/domain/_core/exception/domain_exception.dart';

class Store extends ChangeNotifier {
  bool _isLoading = false;
  DomainException _error = DomainException();

  bool get loading => _isLoading;

  set loading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  DomainException get error => _error;

  set error(DomainException error) {
    _error = error;
    notifyListeners();
  }
}
