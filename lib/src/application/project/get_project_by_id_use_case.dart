import 'package:dartz/dartz.dart';
import 'package:metamorphis/src/domain/_core/exception/domain_exception.dart';
import 'package:metamorphis/src/domain/project/entities/project.dart';
import 'package:metamorphis/src/domain/project/repositories/project_repository.dart';

class GetProjectByIdUseCase {
  late final ProjectRepository _projectRepository;

  GetProjectByIdUseCase({required ProjectRepository projectRepository}) {
    _projectRepository = projectRepository;
  }

  Future<Either<DomainException, Project>> execute(String id) async {
    try {
      final result = await _projectRepository.getById(id);
      return Right(result);
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
