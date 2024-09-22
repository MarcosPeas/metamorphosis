import 'package:archive/archive.dart';
import 'package:change_case/change_case.dart';
import 'package:metamorphis/src/domain/entity/entities/entity.dart';
import 'package:metamorphis/src/infrastructure/code_generators/flutter/flutter_value_objects_generator.dart';

class FlutterEntitiesGenerator {

  FlutterEntitiesGenerator._();

  static List<ArchiveFile> generate({
    required List<Entity> entities,
    required String domainPath,
  }) {
    final files = <ArchiveFile>[];
    for (final entity in entities) {
      _generateEntity(
        entity: entity,
        domainPath: domainPath,
        files: files,
      );
    }
    return files;
  }

  static void _generateEntity({
    required Entity entity,
    required String domainPath,
    required List<ArchiveFile> files,
  }) {
    final entityPath = '$domainPath/${ChangeCase(entity.name).toSnakeCase()}';
    final result = FlutterValueObjectsGenerator.generate(
      entity: entity,
      entityPath: entityPath,
    );
    files.addAll(result);
    final content = _entityContent.replaceAll(
      'name',
      ChangeCase(entity.name).toPascalCase(),
    );
    final archiveFile = ArchiveFile(
      '$entityPath/entities/${ChangeCase(entity.name).toSnakeCase()}.dart',
      content.length,
      content.codeUnits,
    );
    files.add(archiveFile);
  }
}

String _entityContent = '''
import 'package:uuid/uuid.dart';

class name {
}
''';
