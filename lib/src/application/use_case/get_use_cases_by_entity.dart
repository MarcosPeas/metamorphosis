import 'package:dartz/dartz.dart';
import 'package:metamorphis/src/domain/_core/exception/domain_exception.dart';
import 'package:metamorphis/src/domain/entity/entities/entity.dart';
import 'package:metamorphis/src/domain/use_case/entities/use_case.dart';
import 'package:metamorphis/src/domain/use_case/repositories/use_case_repository.dart';

class GetUseCasesByProject {
  late final UseCaseRepository _useCaseRepository;

  GetUseCasesByProject({
    required UseCaseRepository useCaseRepository,
  }) {
    _useCaseRepository = useCaseRepository;
  }

  Future<Either<DomainException, List<UseCase>>> execute(
    Entity entity,
  ) async {
    try {
      final result = await _useCaseRepository.getByEntity(entity.id);
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
