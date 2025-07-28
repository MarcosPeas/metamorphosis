import 'package:archive/archive.dart';

class RustUtils {
  static ArchiveFile genFile({
    required String path,
    required String content,
  }) {
    return ArchiveFile(
      path,
      content.length,
      content.codeUnits,
    );
  }

  static ArchiveFile genMod({
    required String path,
    required List<String> imports,
  }) {
    final modContent = imports.map((import) => 'pub mod $import;').join('\n');
    final file = ArchiveFile(
      '$path/mod.rs',
      modContent.length,
      modContent.codeUnits,
    );
    return file;
  }
}