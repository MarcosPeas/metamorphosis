/*import 'package:dartz/dartz.dart';
import 'package:metamorphis/src/domain/_core/exception/domain_exception.dart';
import 'package:metamorphis/src/domain/bounded_context/entities/bounded_context.dart';
import 'package:metamorphis/src/domain/bounded_context/repositories/bounded_context_repository.dart';

class UpdateBoundedContextUseCase {
  late final BoundedContextRepository _boundedContextRepository;

  UpdateBoundedContextUseCase({required BoundedContextRepository boundedContextRepository}) {
    _boundedContextRepository = boundedContextRepository;
  }

  Future<Either<DomainException, BoundedContext>> execute(BoundedContext boundedContext) async {
    try {
      final result = await _boundedContextRepository.update(boundedContext);
      return Right(result);
    } on DomainException catch (e) {
      return Left(e);
    } catch (e, s) {
      return Left(
        DomainException.of(
          message: e.toString(),
          trace: s.toString(),
          context: 'UpdateBoundedContextUseCase',
        ),
      );
    }
  }
}*/
