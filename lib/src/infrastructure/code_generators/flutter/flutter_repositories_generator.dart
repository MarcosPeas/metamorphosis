import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:change_case/change_case.dart';
import 'package:metamorphis/src/domain/entity/entities/entity.dart';
import 'package:metamorphis/src/domain/use_case/entities/use_case.dart';

class FlutterRepositoriesGenerator {
  FlutterRepositoriesGenerator._();

  static List<ArchiveFile> generate({
    required List<Entity> entities,
    required String domainPath,
  }) {
    final files = <ArchiveFile>[];

    for (final entity in entities) {
      _generateRepositories(
        entity: entity,
        domainPath: domainPath,
        files: files,
      );
    }
    return files;
  }

  static void _generateRepositories({
    required Entity entity,
    required String domainPath,
    required List<ArchiveFile> files,
  }) {
    final entityPath = '$domainPath/${ChangeCase(entity.name).toSnakeCase()}';
    final repositoriesPath = '$entityPath/repositories';
    final result = _generateRepository(
      entity: entity,
      repositoryPath: repositoriesPath,
    );
    files.add(result);
  }

  static ArchiveFile _generateRepository({
    required Entity entity,
    required String repositoryPath,
  }) {
    String content = _repositoryContent;
    final imports = _generateImports(entity);
    final entityNamePascal = ChangeCase(entity.name).toPascalCase();
    final name = '${entityNamePascal}Repository';
    content = content.replaceAll('%imports%', imports);
    content = content.replaceAll('%name%', name);
    String methods = entity.useCases
        .map((useCase) => _generateMethods(entity, useCase))
        .join('\n\n');
    if (methods.contains('delete') && !methods.contains('findById')) {
      final pascalName = ChangeCase(entity.name).toPascalCase();
      methods += '\n\n  Future<$pascalName?> findById(String id);';
    }
    final findUniques =
        entity.valueObjects.where((vo) => vo.isUnique).map((vo) {
      final pascalName = ChangeCase(vo.name).toPascalCase();
      final camelName = ChangeCase(vo.name).toCamelCase();
      return '  Future<$entityNamePascal?> findBy$pascalName(${vo.type} $camelName);';
    }).join('\n\n');
    if (findUniques.isNotEmpty) {
      methods += '\n\n$findUniques';
    }
    content = content.replaceAll('%methods%', methods);
    final entityName = ChangeCase(entity.name).toSnakeCase();
    final path = '$repositoryPath/${entityName}_repository.dart';
    final bytes = utf8.encode(content);
    return ArchiveFile.noCompress(path, bytes.length, bytes);
  }

  static String _generateImports(Entity entity) {
    final entityName = ChangeCase(entity.name).toSnakeCase();
    return 'import \'../entities/$entityName.dart\';';
  }

  static String _generateMethods(Entity entity, UseCase useCase) {
    final pascalName = ChangeCase(entity.name).toPascalCase();
    final camelName = ChangeCase(entity.name).toCamelCase();
    if (useCase.useCaseType == UseCaseType.create) {
      return '  Future<$pascalName> save($pascalName $camelName);';
    } else if (useCase.useCaseType == UseCaseType.update) {
      return '  Future<$pascalName> update($pascalName $camelName);';
    } else if (useCase.useCaseType == UseCaseType.findOne) {
      return '  Future<$pascalName?> findById(String id);';
    } else if (useCase.useCaseType == UseCaseType.delete) {
      return '  Future<void> delete(String id);';
    } else if (useCase.useCaseType == UseCaseType.paginate) {
      return '  Future<List<$pascalName>> paginate({\n    required int limit,\n    required int offset,\n    required String searchField,\n    required String searchValue,\n    required String orderByField,\n    required bool isAscending\n  });';
    }
    return '';
  }
}

String _repositoryContent = '''
%imports%

abstract class %name% {
%methods%
}
''';
