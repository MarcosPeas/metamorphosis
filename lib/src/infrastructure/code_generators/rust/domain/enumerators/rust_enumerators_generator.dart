import 'package:archive/archive.dart';
import 'package:change_case/change_case.dart';
import 'package:metamorphis/src/domain/global_enumerator/entities/global_enumerator.dart';
import 'package:metamorphis/src/infrastructure/code_generators/rust/utils/rust_utils.dart';

class RustEnumeratorsGenerator {
  static List<ArchiveFile> generate(List<GlobalEnumerator> enumerators) {
    final files = enumerators.map((ge) {
      final name = ge.name.toPascalCase();
      final nameSnake = ge.name.toSnakeCase();
      final values = ge.values.replaceAll(' ', '').split(',').map((e) {
        return e.toCamelCase();
      }).toList().join(', ');
      String content = _enumContent.replaceAll('{name}', name);
      content = content.replaceAll('{values}', values);
      return RustUtils.genFile(
        path: 'src/domain/_core/enumerators/$nameSnake.rs',
        content: content,
      );
    });
    final mods = enumerators.map((ge) {
      return ge.name.toSnakeCase();
    }).toList();
    final mod = RustUtils.genMod(
      path: 'src/domain/_core/enumerators/',
      imports: mods,
    );
    return [mod, ...files];
  }
}

String _enumContent = '''
pub enum {name} {
    {values}
}
''';
