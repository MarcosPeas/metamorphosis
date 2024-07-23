import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'splash_controller.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  late final SplashController controller;

  @override
  void initState() {
    controller = GetIt.I.get<SplashController>();
    controller.loadDependencies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Splash Page'),
      ),
    );
  }
}
