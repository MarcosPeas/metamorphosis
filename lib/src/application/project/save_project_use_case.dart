import 'package:dartz/dartz.dart';
import 'package:metamorphis/src/domain/_core/exception/domain_exception.dart';
import 'package:metamorphis/src/domain/project/entities/project.dart';
import 'package:metamorphis/src/domain/project/repositories/project_repository.dart';

class SaveProjectUseCase {
  late final ProjectRepository _projectRepository;

  SaveProjectUseCase({required ProjectRepository projectRepository}) {
    _projectRepository = projectRepository;
  }

  Future<Either<DomainException, Project>> execute(Project project) async {
    try {
      final result = await _projectRepository.save(project);
      return Right(result);
    } on DomainException catch (e) {
      return Left(e);
    } catch (e, s) {
      return Left(
        DomainException.of(
          message: e.toString(),
          trace: s.toString(),
          context: 'SaveProjectUseCase',
        ),
      );
    }
  }
}
