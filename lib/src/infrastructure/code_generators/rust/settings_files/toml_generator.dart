import 'package:archive/archive.dart';
import 'package:change_case/change_case.dart';
import 'package:metamorphis/src/domain/application/entities/application.dart';

class TomlGenerator {
  static ArchiveFile generate(Application application) {
    String tomlContent = _tomlTemplate.replaceFirst(
      "%NAME%",
      application.name.toSnakeCase(),
    );
    final file = ArchiveFile(
      'Cargo.toml',
      tomlContent.length,
      tomlContent.codeUnits,
    );
    return file;
  }
}

const _tomlTemplate = '''
[package]
name = "%NAME%"
version = "0.1.0"
edition = "2021"

[dependencies]
chrono = "0.4.41"
uuid = { version = "1.17.0", features = ["v7"] }
''';
