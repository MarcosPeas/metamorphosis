import 'package:dartz/dartz.dart';
import 'package:metamorphis/src/domain/_core/domain/repository.dart';
import 'package:metamorphis/src/domain/_core/exception/domain_exception.dart';
import 'package:metamorphis/src/domain/project/entities/project.dart';
import 'package:metamorphis/src/domain/project/repositories/project_repository.dart';

class GetProjectsByUserUseCase {
  late final ProjectRepository _projectRepository;

  GetProjectsByUserUseCase({required ProjectRepository projectRepository}) {
    _projectRepository = projectRepository;
  }

  Future<Either<DomainException, List<Project>>> execute(
    PaginateParams params,
  ) async {
    try {
      final result = await _projectRepository.paginate(params);
      return Right(result);
    } on DomainException catch (e) {
      return Left(e);
    } catch (e, s) {
      return Left(
        DomainException.of(
          message: e.toString(),
          trace: s.toString(),
          context: 'GetProjectsByUserUseCase',
        ),
      );
    }
  }
}
