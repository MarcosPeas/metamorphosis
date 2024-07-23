import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:metamorphis/src/presenter/_core/firebase_options.dart';

class SplashController {
  Future<void> loadDependencies() async {
    final result = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    log('carregou o firebase na web');
    log('${result.name}, ${result.options.apiKey}, ${result.options.projectId}, ${result.options.messagingSenderId}');
  }
}
