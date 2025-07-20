import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension NavigationExtension on BuildContext {
  void pushNamedAndRemoveUntil(String route, {Object? extra}) {
    go(route);
    pushReplacementNamed(route, extra: extra);
  }
}
