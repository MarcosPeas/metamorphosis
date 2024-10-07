import 'package:flutter/material.dart';

class DialogChangeTargetStore extends ChangeNotifier {
  String? _target;

  String? get target => _target;

  set target(String? target) {
    _target = target;
    notifyListeners();
  }
}