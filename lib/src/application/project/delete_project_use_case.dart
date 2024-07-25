import 'package:dartz/dartz.dart';
import 'package:metamorphis/src/domain/_core/exception/domain_exception.dart';
import 'package:metamorphis/src/domain/project/entities/project.dart';
import 'package:metamorphis/src/domain/project/repositories/project_repository.dart';

class DeleteProjectUseCase {
  late final ProjectRepository _projectRepository;

  DeleteProjectUseCase({required ProjectRepository projectRepository}) {
    _projectRepository = projectRepository;
  }

  Future<Either<DomainException, Unit>> execute(Project project) async {
    try {
      await _projectRepository.delete(project.id);
      return const Right(unit);
    } on DomainException catch (e) {
      return Left(e);
    } catch (e, s) {
      return Left(
        DomainException(
          message: e.toString(),
          trace: s.toString(),
        ),
      );
    }
  }
}
