import 'package:archive/archive_io.dart';
import 'package:metamorphis/src/domain/project/entities/project.dart';
import 'package:metamorphis/src/infrastructure/code_generators/flutter/flutter_generator.dart';

class CodeGenerators {
  CodeGenerators._();

  static Archive generateCode({
    required Project project,
  }) {
    return FlutterGenerator.generate(
      project: project,
    );
  }
}
