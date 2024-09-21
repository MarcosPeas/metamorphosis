import 'package:archive/archive_io.dart';
import 'package:metamorphis/src/domain/application/entities/application.dart';
import 'package:metamorphis/src/infrastructure/code_generators/flutter/flutter_generator.dart';

class CodeGenerators {
  CodeGenerators._();

  static Archive generateCode({
    required Application application,
  }) {
    return FlutterGenerator.generate(
      application: application,
    );
  }
}
