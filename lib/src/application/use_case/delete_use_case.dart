import 'package:dartz/dartz.dart';
import 'package:metamorphis/src/domain/_core/exception/domain_exception.dart';
import 'package:metamorphis/src/domain/use_case/entities/use_case.dart';
import 'package:metamorphis/src/domain/use_case/repositories/use_case_repository.dart';

class DeleteUseCase {
  late final UseCaseRepository _useCaseRepository;

  DeleteUseCase({
    required UseCaseRepository useCaseRepository,
  }) {
    _useCaseRepository = useCaseRepository;
  }

  Future<Either<DomainException, Unit>> execute(UseCase useCase) async {
    try {
      await _useCaseRepository.delete(useCase);
      return const Right(unit);
    } on DomainException catch (e) {
      return Left(e);
    } catch (e, s) {
      return Left(
        DomainException.of(
          message: e.toString(),
          trace: s.toString(),
          context: 'DeleteUseCase',
        ),
      );
    }
  }
}
