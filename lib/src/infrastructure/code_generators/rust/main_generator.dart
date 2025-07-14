import 'package:archive/archive.dart';
import 'package:metamorphis/src/domain/application/entities/application.dart';

class MainGenerator {
  static ArchiveFile generate(Application application) {
    String mainContent = '''
    fn main() {
        println!("Hello, world!");
    }
    ''';
    mainContent = mainContent.replaceAll('/t', '').trim();
    final file = ArchiveFile(
      'src/main.rs',
      mainContent.length,
      mainContent.codeUnits,
    );
    return file;
  }
}