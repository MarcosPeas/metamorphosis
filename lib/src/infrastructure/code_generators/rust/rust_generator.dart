import 'package:metamorphis/src/domain/application/entities/application.dart';
import 'package:archive/archive.dart';
import 'package:change_case/change_case.dart';
import 'package:metamorphis/src/infrastructure/code_generators/rust/settings_files/builds_generator.dart';

import 'main_generator.dart';
import 'settings_files/toml_generator.dart';

class RustGenerator {
  RustGenerator._();

  static Archive generate({
    required Application application,
  }) {
    final archive = Archive();
    final main = MainGenerator.generate(application);
    final toml = TomlGenerator.generate(application);
    final builds = BuildsGenerator.generate(application);
    final applicationName = ChangeCase(application.name).toSnakeCase();

    archive.addFile(main);
    archive.addFile(toml);
    builds.forEach(archive.addFile);
    return archive;
  }
}
