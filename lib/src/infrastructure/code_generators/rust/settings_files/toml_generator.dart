import 'package:archive/archive.dart';
import 'package:change_case/change_case.dart';
import 'package:metamorphis/src/domain/application/entities/application.dart';

class TomlGenerator {
  static ArchiveFile generate(Application application) {
    String tomlContent = '''
        [package]
        name = "${application.name.toSnakeCase()}"
        version = "0.1.0"
        edition = "2021"

        [dependencies]
    ''';
    tomlContent = tomlContent.replaceAll('/t', '').trim();
    final file = ArchiveFile(
      'Cargo.toml',
      tomlContent.length,
      tomlContent.codeUnits,
    );
    return file;
  }
}
