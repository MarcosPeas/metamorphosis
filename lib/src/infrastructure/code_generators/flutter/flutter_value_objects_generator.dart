import 'package:archive/archive.dart';
import 'package:change_case/change_case.dart';
import 'package:metamorphis/src/domain/entity/entities/entity.dart';
import 'package:metamorphis/src/domain/value_object/entities/value_object.dart';

class FlutterValueObjectsGenerator {
  FlutterValueObjectsGenerator._();

  static List<ArchiveFile> generate({
    required Entity entity,
    required String entityPath,
  }) {
    List<ArchiveFile> files = [];
    for (final valueObject in entity.valueObjects) {
      final result = _generateValueObject(
        valueObject: valueObject,
        entityPath: entityPath,
        entity: entity,
      );
      files.add(result);
    }
    return files;
  }

  static ArchiveFile _generateValueObject({
    required ValueObject valueObject,
    required String entityPath,
    required Entity entity,
  }) {
    final content = _valueObjectContent.replaceAll(
      '%name%',
      ChangeCase('${entity.name}_${valueObject.name}').toPascalCase(),
    );
    return ArchiveFile(
      '$entityPath/value_objects/${ChangeCase('${entity.name}_${valueObject.name}').toSnakeCase()}.dart',
      content.length,
      content,
    );
  }
}

String _valueObjectContent = '''
class %name% {
}
''';
