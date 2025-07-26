import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:change_case/change_case.dart';
import 'package:metamorphis/src/domain/entity/entities/entity.dart';
import 'package:metamorphis/src/domain/use_case/entities/use_case.dart';

class FlutterRepositoriesSupabaseGenerator {
  static List<ArchiveFile> generate({
    required List<Entity> entities,
    required String dataPath,
    required String domainPath,
  }) {
    final files = <ArchiveFile>[];
    final apiError = _generateApiError(
      domainPath: domainPath,
      dataPath: dataPath,
    );
    for (final entity in entities) {
      _generateRepositories(
        entity: entity,
        dataPath: dataPath,
        domainPath: domainPath.replaceAll('/lib', ''),
        files: files,
      );
    }
    files.add(apiError);
    return files;
  }

  static void _generateRepositories({
    required Entity entity,
    required String dataPath,
    required String domainPath,
    required List<ArchiveFile> files,
  }) {
    final result = _generateRepository(
      entity: entity,
      dataPath: dataPath,
      domainPath: domainPath,
    );
    files.add(result);
  }

  static ArchiveFile _generateRepository({
    required Entity entity,
    required String dataPath,
    required String domainPath,
  }) {
    String content = _repositoryContent;
    final imports = _generateImports(
      entity: entity,
      domainPath: domainPath,
      dataPath: dataPath,
    );
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
    final path =
        '$dataPath/$entityName/repositories/${entityName}_repository_impl.dart';
    final bytes = utf8.encode(content);
    return ArchiveFile.noCompress(path, bytes.length, bytes);
  }

  static String _generateImports({
    required Entity entity,
    required String domainPath,
    required String dataPath,
  }) {
    String imports = '';
    final entityName = entity.name.toSnakeCase();
    imports +=
        'import \'package:$domainPath/$entityName/entities/$entityName.dart\';\n';
    imports +=
        'import \'package:$domainPath/$entityName/repositories/${entityName}_repository.dart\';\n';
    imports +=
        'import \'package:${dataPath.replaceAll('/lib', '')}/$entityName/models/${entityName}_model.dart\';\n';
    return imports;
  }

  static String _generateMethods(Entity entity, UseCase useCase) {
    final pascalName = ChangeCase(entity.name).toPascalCase();
    final camelName = ChangeCase(entity.name).toCamelCase();
    if (useCase.useCaseType == UseCaseType.create) {
      return _generateSave(entity, useCase);
    } else if (useCase.useCaseType == UseCaseType.update) {
      return '  Future<$pascalName> update($pascalName $camelName);';
    } else if (useCase.useCaseType == UseCaseType.filterOne) {
      return '  Future<$pascalName?> findById(String id);';
    } else if (useCase.useCaseType == UseCaseType.delete) {
      return '  Future<void> delete(String id);';
    } else if (useCase.useCaseType == UseCaseType.paginate) {
      return '  Future<List<$pascalName>> paginate({\n    required int limit,\n    required int offset,\n    required String searchField,\n    required String searchValue,\n    required String orderByField,\n    required bool isAscending\n  });';
    }
    return '';
  }

  static String _generateSave(Entity entity, UseCase useCase) {
    final pascalName = ChangeCase(entity.name).toPascalCase();
    final camelName = ChangeCase(entity.name).toCamelCase();
    String content = '    try {';
    content +=
        '\n      final model = ${pascalName}Model.fromEntity($camelName);';
    content += '\n      await supabase.from(\'${entity.name.toSnakeCase()}\')';
    content += '.insert(model.toJson());';
    content += '\n      return $camelName;';
    content += '\n    } catch (e, s) {\n';
    content += '      rethrow;\n';
    content += '    }';
    return '  Future<$pascalName> save($pascalName $camelName) async {\n$content\n  }';
  }

  static ArchiveFile _generateApiError({
    required String domainPath,
    required String dataPath,
  }) {
    final path = '$dataPath/_core/supabase_exception.dart';
    String content = _supabaseException;
    content = content.replaceAll(
      '%imports%',
      '',
    );
    final bytes = utf8.encode(content);
    final file = ArchiveFile.noCompress(
      path,
      bytes.length,
      bytes,
    );
    return file;
  }
}

String _repositoryContent = '''
import 'package:supabase/supabase.dart';
%imports%

class %name%Impl extends %name% {
  final SupabaseClient supabase;
  
  %name%Impl(this.supabase);
  
%methods%
}
''';

String _supabaseException = '''
%imports%

class SupabaseException extends DomainException {
  SupabaseException({
    super.errors,
  });
}
''';
