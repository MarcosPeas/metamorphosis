import 'package:archive/archive.dart';
import 'package:metamorphis/src/domain/entity/entities/entity.dart';
import 'package:metamorphis/src/domain/use_case/entities/use_case.dart';

class FlutterUseCasesGenerator {
  FlutterUseCasesGenerator._();

  static List<ArchiveFile> generate(
    String applicationPath,
    List<Entity> entities,
  ) {
    final archives = <ArchiveFile>[];
    for (final entity in entities) {
      final entityArchives = _generateUseCases(applicationPath, entity);
      archives.addAll(entityArchives);
    }
    return archives;
  }

  static List<ArchiveFile> _generateUseCases(
    String applicationPath,
    Entity entity,
  ) {
    final archives = <ArchiveFile>[];
    final useCases = entity.useCases;
    for (final useCase in useCases) {
     // final archive = _generateUseCase(applicationPath, useCase);
    //  archives.add(archive);
    }
    return archives;
  }

 /* static ArchiveFile _generateUseCase(
    String entityPath,
    UseCase useCase,
  ) {
    if (useCase.useCaseType == UseCaseType.create) {
      return _generateCreateUseCase(entityPath, useCase);
    } else if (useCase.useCaseType == UseCaseType.read) {
      return _generateReadUseCase(entityPath, useCase);
    } else if (useCase.useCaseType == UseCaseType.update) {
      return _generateUpdateUseCase(entityPath, useCase);
    } else if (useCase.useCaseType == UseCaseType.delete) {
      return _generateDeleteUseCase(entityPath, useCase);
    } else if (useCase.useCaseType == UseCaseType.paginate) {
      return _generatePaginateUseCase(entityPath, useCase);
    } else {
      throw Exception('Use case type not found');
    }
  }

  static ArchiveFile _generateCreateUseCase(
    String entityPath,
    UseCase useCase,
  ) {

  }*/
}
/*
const _createUseCase = '''

''';*/

