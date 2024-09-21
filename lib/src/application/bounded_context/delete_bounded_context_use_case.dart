import 'package:dartz/dartz.dart';
import 'package:metamorphis/src/domain/_core/exception/domain_exception.dart';
import 'package:metamorphis/src/domain/bounded_context/entities/bounded_context.dart';
import 'package:metamorphis/src/domain/bounded_context/repositories/bounded_context_repository.dart';

class DeleteBoundedContextUseCase {
  late final BoundedContextRepository _boundedContextRepository;

  DeleteBoundedContextUseCase({
    required BoundedContextRepository boundedContextRepository,
  }) {
    _boundedContextRepository = boundedContextRepository;
  }

  Future<Either<DomainException, Unit>> execute(
      BoundedContext boundedContext,
      ) async {
    try {
      await _boundedContextRepository.delete(boundedContext.id);
      return const Right(unit);
    } on DomainException catch (e) {
      return Left(e);
    } catch (e, s) {
      return Left(
        DomainException.of(
          message: e.toString(),
          trace: s.toString(),
          context: 'DeleteBoundedContextUseCase',
        ),
      );
    }
  }
}
