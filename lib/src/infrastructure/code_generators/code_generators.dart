import 'package:archive/archive_io.dart';
import 'package:metamorphis/src/domain/application/entities/application.dart';
import 'package:metamorphis/src/infrastructure/code_generators/flutter/flutter_generator.dart';
import 'package:metamorphis/src/infrastructure/code_generators/rust/rust_generator.dart';

class CodeGenerators {
  CodeGenerators._();

  static Archive generateCode({
    required Application application,
    required GeneratorTarget target,
  }) {
    if (target == GeneratorTarget.rust) {
      return RustGenerator.generate(application: application);
    }
    return FlutterGenerator.generate(application: application);
  }
}

enum GeneratorTarget { flutter, rust, golang }
