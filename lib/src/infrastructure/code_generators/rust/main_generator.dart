import 'package:archive/archive.dart';
import 'package:metamorphis/src/domain/application/entities/application.dart';

class MainGenerator {
  static ArchiveFile generate(Application application) {
    final file = ArchiveFile(
      'src/main.rs',
      _mainContent.length,
      _mainContent.codeUnits,
    );
    return file;
  }
}

String _mainContent = '''
mod domain;

fn main() {
    println!("Hello, world!");
}
''';