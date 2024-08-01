import 'package:dartz/dartz.dart';
import 'package:metamorphis/src/domain/_core/exception/domain_exception.dart';
import 'package:metamorphis/src/domain/use_case/entities/use_case.dart';
import 'package:metamorphis/src/domain/use_case/repositories/use_case_repository.dart';

class UpdateUseCase {
  late final UseCaseRepository _useCaseRepository;

  UpdateUseCase({required UseCaseRepository useCaseRepository}) {
    _useCaseRepository = useCaseRepository;
  }

  Future<Either<DomainException, UseCase>> execute(UseCase useCase) async {
    try {
      final result = await _useCaseRepository.update(useCase);
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
