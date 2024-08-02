import 'package:dartz/dartz.dart';
import 'package:metamorphis/src/domain/_core/exception/domain_exception.dart';
import 'package:metamorphis/src/domain/project/entities/project.dart';
import 'package:metamorphis/src/domain/project/repositories/project_repository.dart';
import 'package:metamorphis/src/domain/user/entities/user.dart';

class GetProjectsByUserUseCase {
  late final ProjectRepository _projectRepository;

  GetProjectsByUserUseCase({required ProjectRepository projectRepository}) {
    _projectRepository = projectRepository;
  }

  Future<Either<DomainException, List<Project>>> execute(User user) async {
    try {
      final result = await _projectRepository.getByUser(user.id);
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
