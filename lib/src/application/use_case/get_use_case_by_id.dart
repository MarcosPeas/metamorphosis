import 'package:dartz/dartz.dart';
import 'package:metamorphis/src/domain/_core/exception/domain_exception.dart';
import 'package:metamorphis/src/domain/use_case/entities/use_case.dart';
import 'package:metamorphis/src/domain/use_case/repositories/use_case_repository.dart';

class GetByIdUseCase {
  late final UseCaseRepository _useCaseRepository;

  GetByIdUseCase({
    required UseCaseRepository useCaseRepository,
  }) {
    _useCaseRepository = useCaseRepository;
  }

  Future<Either<DomainException, UseCase>> execute(
    String id
  ) async {
    try {
      final result = await _useCaseRepository.getById(id);
      return Right(result);
    } on DomainException catch (e) {
      return Left(e);
    } catch (e, s) {
      return Left(
        DomainException.of(
          message: e.toString(),
          trace: s.toString(),
          context: 'GetByIdUseCase',
        ),
      );
    }
  }
}
