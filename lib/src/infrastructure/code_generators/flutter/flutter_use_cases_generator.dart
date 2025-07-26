import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:change_case/change_case.dart';
import 'package:metamorphis/src/domain/entity/entities/entity.dart';
import 'package:metamorphis/src/domain/use_case/entities/use_case.dart';

class FlutterUseCasesGenerator {
  FlutterUseCasesGenerator._();

  static List<ArchiveFile> generate({
    required String applicationPath,
    required String applicationNameSnakeCase,
    required String domainPath,
    required List<Entity> entities,
  }) {
    final archives = <ArchiveFile>[];
    for (final entity in entities) {
      final entityArchives = _generateUseCases(
        applicationPath: applicationPath,
        domainPath: domainPath,
        entity: entity,
        applicationNameSnakeCase: applicationNameSnakeCase,
      );
      archives.addAll(entityArchives);
    }
    return archives;
  }

  static List<ArchiveFile> _generateUseCases({
    required String applicationPath,
    required String domainPath,
    required Entity entity,
    required String applicationNameSnakeCase,
  }) {
    final archives = <ArchiveFile>[];
    final useCases = entity.useCases;
    for (final useCase in useCases) {
      final archive = _generateUseCase(
        applicationPath: applicationPath,
        domainPath: domainPath,
        useCase: useCase,
        entity: entity,
        applicationNameSnakeCase: applicationNameSnakeCase,
      );
      if (archive != null) {
        archives.add(archive);
      }
    }
    return archives;
  }

  static ArchiveFile? _generateUseCase({
    required String applicationPath,
    required String domainPath,
    required UseCase useCase,
    required Entity entity,
    required String applicationNameSnakeCase,
  }) {
    if (useCase.useCaseType == UseCaseType.create) {
      return _generateCreateUseCase(
        applicationPath: applicationPath,
        domainPath: domainPath,
        useCase: useCase,
        entity: entity,
        applicationNameSnakeCase: applicationNameSnakeCase,
      );
    } else if (useCase.useCaseType == UseCaseType.filterOne) {
      return _generateFindByIdUseCase(
        applicationPath: applicationPath,
        domainPath: domainPath,
        useCase: useCase,
        entity: entity,
        applicationNameSnakeCase: applicationNameSnakeCase,
      );
    } else if (useCase.useCaseType == UseCaseType.update) {
      return _generateUpdateUseCase(
        applicationPath: applicationPath,
        domainPath: domainPath,
        useCase: useCase,
        entity: entity,
        applicationNameSnakeCase: applicationNameSnakeCase,
      );
    } else if (useCase.useCaseType == UseCaseType.delete) {
      return _generateDeleteUseCase(
        applicationPath: applicationPath,
        domainPath: domainPath,
        useCase: useCase,
        entity: entity,
        applicationNameSnakeCase: applicationNameSnakeCase,
      );
    } else if (useCase.useCaseType == UseCaseType.paginate) {
      return _generatePaginateUseCase(
        applicationPath: applicationPath,
        domainPath: domainPath,
        useCase: useCase,
        entity: entity,
        applicationNameSnakeCase: applicationNameSnakeCase,
      );
    }
    return null;
  }

  static ArchiveFile _generateCreateUseCase({
    required String applicationPath,
    required String domainPath,
    required UseCase useCase,
    required Entity entity,
    required String applicationNameSnakeCase,
  }) {
    String content = _createUseCase;
    final entityName = ChangeCase(entity.name).toPascalCase();
    final entityNameCamelCase = ChangeCase(entity.name).toCamelCase();
    final entityNameSnakeCase = ChangeCase(entity.name).toSnakeCase();
    content = content.replaceAll('%uniqueFields%', _addUniqueFields(entity));
    content = content.replaceAll('%application%', applicationNameSnakeCase);
    content = content.replaceAll('%domainPath%', domainPath);
    content = content.replaceAll('%entityName%', entityNameSnakeCase);
    content = content.replaceAll('%entityNamePascalCase%', entityName);
    content = content.replaceAll('%entityNameCamelCase%', entityNameCamelCase);
    final path =
        '$applicationPath/$entityNameSnakeCase/create_${entityNameSnakeCase}_use_case.dart';
    final bytes = utf8.encode(content);
    return ArchiveFile.noCompress(path, bytes.length, bytes);
  }

  static ArchiveFile _generateDeleteUseCase({
    required String applicationPath,
    required String domainPath,
    required UseCase useCase,
    required Entity entity,
    required String applicationNameSnakeCase,
  }) {
    String content = _deleteUseCase;
    final entityName = ChangeCase(entity.name).toPascalCase();
    final entityNameCamelCase = ChangeCase(entity.name).toCamelCase();
    final entityNameSnakeCase = ChangeCase(entity.name).toSnakeCase();
    content = content.replaceAll('%application%', applicationNameSnakeCase);
    content = content.replaceAll('%domainPath%', domainPath);
    content = content.replaceAll('%entityName%', entityNameSnakeCase);
    content = content.replaceAll('%entityNamePascalCase%', entityName);
    content = content.replaceAll('%entityNameCamelCase%', entityNameCamelCase);
    final path =
        '$applicationPath/$entityNameSnakeCase/delete_${entityNameSnakeCase}_use_case.dart';
    final bytes = utf8.encode(content);
    return ArchiveFile.noCompress(path, bytes.length, bytes);
  }

  static ArchiveFile _generateFindByIdUseCase({
    required String applicationPath,
    required String domainPath,
    required UseCase useCase,
    required Entity entity,
    required String applicationNameSnakeCase,
  }) {
    String content = _findByIdUseCase;
    final entityName = ChangeCase(entity.name).toPascalCase();
    final entityNameCamelCase = ChangeCase(entity.name).toCamelCase();
    final entityNameSnakeCase = ChangeCase(entity.name).toSnakeCase();
    content = content.replaceAll('%application%', applicationNameSnakeCase);
    content = content.replaceAll('%domainPath%', domainPath);
    content = content.replaceAll('%entityName%', entityNameSnakeCase);
    content = content.replaceAll('%entityNamePascalCase%', entityName);
    content = content.replaceAll('%entityNameCamelCase%', entityNameCamelCase);
    final path =
        '$applicationPath/$entityNameSnakeCase/find_${entityNameSnakeCase}_by_id_use_case.dart';
    final bytes = utf8.encode(content);
    return ArchiveFile.noCompress(path, bytes.length, bytes);
  }

  static ArchiveFile _generateUpdateUseCase({
    required String applicationPath,
    required String domainPath,
    required UseCase useCase,
    required Entity entity,
    required String applicationNameSnakeCase,
  }) {
    String content = _updateUseCase;
    final entityName = ChangeCase(entity.name).toPascalCase();
    final entityNameCamelCase = ChangeCase(entity.name).toCamelCase();
    final entityNameSnakeCase = ChangeCase(entity.name).toSnakeCase();
    content = content.replaceAll('%uniqueFields%', _addUniqueFieldsForUpdate(entity));
    content = content.replaceAll('%application%', applicationNameSnakeCase);
    content = content.replaceAll('%domainPath%', domainPath);
    content = content.replaceAll('%entityName%', entityNameSnakeCase);
    content = content.replaceAll('%entityNamePascalCase%', entityName);
    content = content.replaceAll('%entityNameCamelCase%', entityNameCamelCase);
    final path =
        '$applicationPath/$entityNameSnakeCase/update_${entityNameSnakeCase}_use_case.dart';
    final bytes = utf8.encode(content);
    return ArchiveFile.noCompress(path, bytes.length, bytes);
  }

  static ArchiveFile _generatePaginateUseCase({
    required String applicationPath,
    required String domainPath,
    required UseCase useCase,
    required Entity entity,
    required String applicationNameSnakeCase,
  }) {
    String content = _paginateUseCase;
    final entityName = ChangeCase(entity.name).toPascalCase();
    final entityNameCamelCase = ChangeCase(entity.name).toCamelCase();
    final entityNameSnakeCase = ChangeCase(entity.name).toSnakeCase();
    content = content.replaceAll('%application%', applicationNameSnakeCase);
    content = content.replaceAll('%domainPath%', domainPath);
    content = content.replaceAll('%entityName%', entityNameSnakeCase);
    content = content.replaceAll('%entityNamePascalCase%', entityName);
    content = content.replaceAll('%entityNameCamelCase%', entityNameCamelCase);
    final path =
        '$applicationPath/$entityNameSnakeCase/paginate_${entityNameSnakeCase}_use_case.dart';
    final bytes = utf8.encode(content);
    return ArchiveFile.noCompress(path, bytes.length, bytes);
  }

  static String _addUniqueFields(Entity entity) {
    final uniqueFields = entity.valueObjects.where((field) => field.isUnique);
    String content = '';
    final entityNameCamelCase = ChangeCase(entity.name).toCamelCase();
    for (final field in uniqueFields) {
      final fieldNameCamel = ChangeCase(field.name).toCamelCase();
      final fieldNamePasCal = ChangeCase(field.name).toPascalCase();
      const s = '      ';
      content +=
          '${s}final entityWith$fieldNamePasCal = await _%entityNameCamelCase%Repository.findBy$fieldNamePasCal($entityNameCamelCase.$fieldNameCamel);\n';
      content += '${s}if (entityWith$fieldNamePasCal != null) {\n';
      content += '$s  return Left(DomainException.of(\n';
      content += '$s    message: \'$fieldNamePasCal already exists\',\n';
      content += '$s    context: \'Create%entityNamePascalCase%UseCase\',\n';
      content += '$s  ));\n';
      content += '$s}\n';
    }
    return content;
  }

  static String _addUniqueFieldsForUpdate(Entity entity) {
    final uniqueFields = entity.valueObjects.where((field) => field.isUnique);
    String content = '';
    final entityNameCamelCase = ChangeCase(entity.name).toCamelCase();
    for (final field in uniqueFields) {
      final fieldNameCamel = ChangeCase(field.name).toCamelCase();
      final fieldNamePasCal = ChangeCase(field.name).toPascalCase();
      const s = '      ';
      content +=
          '${s}final entityWith$fieldNamePasCal = await _%entityNameCamelCase%Repository.findBy$fieldNamePasCal($entityNameCamelCase.$fieldNameCamel);\n';
      content += '${s}if (entityWith$fieldNamePasCal != null && %entityNameCamelCase%.id != entityWith$fieldNamePasCal.id) {\n';
      content += '$s  return Left(DomainException.of(\n';
      content += '$s    message: \'$fieldNamePasCal already exists\',\n';
      content += '$s    context: \'Update%entityNamePascalCase%UseCase\',\n';
      content += '$s  ));\n';
      content += '$s}\n';
    }
    return content;
  }
}

const _createUseCase = '''
import 'package:dartz/dartz.dart';
import 'package:%domainPath%/_core/exception/domain_exception.dart';
import 'package:%domainPath%/%entityName%/entities/%entityName%.dart';
import 'package:%domainPath%/%entityName%/repositories/%entityName%_repository.dart';

class Create%entityNamePascalCase%UseCase {
  late final %entityNamePascalCase%Repository _%entityNameCamelCase%Repository;

  Create%entityNamePascalCase%UseCase({required %entityNamePascalCase%Repository %entityNameCamelCase%Repository}) {
    _%entityNameCamelCase%Repository = %entityNameCamelCase%Repository;
  }

  Future<Either<DomainException, %entityNamePascalCase%>> execute(%entityNamePascalCase% %entityNameCamelCase%) async {
    try {
%uniqueFields%      final result = await _%entityNameCamelCase%Repository.save(%entityNameCamelCase%);
      return Right(result);
    } on DomainException catch (e) {
      return Left(e);
    } catch (e, s) {
      return Left(
        DomainException.of(
          message: e.toString(),
          trace: s.toString(),
          context: 'Create%entityNamePascalCase%UseCase',
        ),
      );
    }
  }
}
''';

const _deleteUseCase = '''
import 'package:dartz/dartz.dart';
import 'package:%domainPath%/_core/exception/domain_exception.dart';
import 'package:%domainPath%/%entityName%/entities/%entityName%.dart';
import 'package:%domainPath%/%entityName%/repositories/%entityName%_repository.dart';

class Delete%entityNamePascalCase%UseCase {
  late final %entityNamePascalCase%Repository _%entityNameCamelCase%Repository;

  Delete%entityNamePascalCase%UseCase({required %entityNamePascalCase%Repository %entityNameCamelCase%Repository}) {
    _%entityNameCamelCase%Repository = %entityNameCamelCase%Repository;
  }

  Future<Either<DomainException, void>> execute(%entityNamePascalCase% %entityNameCamelCase%) async {
    try {
      final result = await _%entityNameCamelCase%Repository.findById(%entityNameCamelCase%.id);
      if (result == null) {
        return Left(DomainException.of(
          message: '%entityNamePascalCase% not found',
          context: 'Delete%entityNamePascalCase%UseCase',
        ));
      }
      await _%entityNameCamelCase%Repository.delete(%entityNameCamelCase%.id);
      return Right(null);
    } on DomainException catch (e) {
      return Left(e);
    } catch (e, s) {
      return Left(
        DomainException.of(
          message: e.toString(),
          trace: s.toString(),
          context: 'Delete%entityNamePascalCase%UseCase',
        ),
      );
    }
  }
}
''';

const _findByIdUseCase = '''
import 'package:dartz/dartz.dart';
import 'package:%domainPath%/_core/exception/domain_exception.dart';
import 'package:%domainPath%/%entityName%/entities/%entityName%.dart';
import 'package:%domainPath%/%entityName%/repositories/%entityName%_repository.dart';

class Find%entityNamePascalCase%ByIdUseCase {
  late final %entityNamePascalCase%Repository _%entityNameCamelCase%Repository;

  Find%entityNamePascalCase%ByIdUseCase({required %entityNamePascalCase%Repository %entityNameCamelCase%Repository}) {
    _%entityNameCamelCase%Repository = %entityNameCamelCase%Repository;
  }

  Future<Either<DomainException, %entityNamePascalCase%?>> execute(String id) async {
    try {
      final result = await _%entityNameCamelCase%Repository.findById(id);
      if (result == null) {
        return Left(DomainException.of(
          message: '%entityNamePascalCase% not found',
          context: 'Find%entityNamePascalCase%ByIdUseCase',
        ));
      }     
      return Right(result);
    } on DomainException catch (e) {
      return Left(e);
    } catch (e, s) {
      return Left(
        DomainException.of(
          message: e.toString(),
          trace: s.toString(),
          context: 'Find%entityNamePascalCase%ByIdUseCase',
        ),
      );
    }
  }
}
''';

const _updateUseCase = '''
import 'package:dartz/dartz.dart';
import 'package:%domainPath%/_core/exception/domain_exception.dart';
import 'package:%domainPath%/%entityName%/entities/%entityName%.dart';
import 'package:%domainPath%/%entityName%/repositories/%entityName%_repository.dart';

class Update%entityNamePascalCase%UseCase {
  late final %entityNamePascalCase%Repository _%entityNameCamelCase%Repository;

  Update%entityNamePascalCase%UseCase({required %entityNamePascalCase%Repository %entityNameCamelCase%Repository}) {
    _%entityNameCamelCase%Repository = %entityNameCamelCase%Repository;
  }

  Future<Either<DomainException, %entityNamePascalCase%>> execute(%entityNamePascalCase% %entityNameCamelCase%) async {
    try {
%uniqueFields%      final result = await _%entityNameCamelCase%Repository.update(%entityNameCamelCase%);
      return Right(result);
    } on DomainException catch (e) {
      return Left(e);
    } catch (e, s) {
      return Left(
        DomainException.of(
          message: e.toString(),
          trace: s.toString(),
          context: 'Update%entityNamePascalCase%UseCase',
        ),
      );
    }
  }
}
''';

const _paginateUseCase = '''
import 'package:dartz/dartz.dart';
import 'package:%domainPath%/_core/exception/domain_exception.dart';
import 'package:%domainPath%/%entityName%/entities/%entityName%.dart';
import 'package:%domainPath%/%entityName%/repositories/%entityName%_repository.dart';

class Paginate%entityNamePascalCase%UseCase {
  late final %entityNamePascalCase%Repository _%entityNameCamelCase%Repository;

  Paginate%entityNamePascalCase%UseCase({required %entityNamePascalCase%Repository %entityNameCamelCase%Repository}) {
    _%entityNameCamelCase%Repository = %entityNameCamelCase%Repository;
  }

  Future<Either<DomainException, List<%entityNamePascalCase%>>> execute({
    required int limit,
    required int offset,
    required String searchField,
    required String searchValue,
    required String orderByField,
    required bool isAscending,
  }) async {
    try {
      final result = await _%entityNameCamelCase%Repository.paginate(
        limit: limit,
        offset: offset,
        searchField: searchField,
        searchValue: searchValue,
        orderByField: orderByField,
        isAscending: isAscending,
      );     
      return Right(result);
    } on DomainException catch (e) {
      return Left(e);
    } catch (e, s) {
      return Left(
        DomainException.of(
          message: e.toString(),
          trace: s.toString(),
          context: 'Paginate%entityNamePascalCase%UseCase',
        ),
      );
    }
  }
}
''';
