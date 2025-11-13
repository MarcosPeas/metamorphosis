
import 'dart:convert';

import 'package:archive/archive_io.dart';

class RustUtils {

  RustUtils._();

  static ArchiveFile genFile({required String path, required String content}) {
    return ArchiveFile.bytes(
      path,
      utf8.encode(content),
    );
  }

  static ArchiveFile genMod({
    required String path,
    required List<String> imports,
  }) {
    if (!path.endsWith('/')) {
      path += '/';
    }
    final modContent = imports.map((import) => 'pub mod $import;').join('\n');
    final file = ArchiveFile(
      '${path}mod.rs',
      modContent.length,
      modContent.codeUnits,
    );
    return file;
  }
}
