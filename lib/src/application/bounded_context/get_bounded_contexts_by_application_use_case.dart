/*import 'package:dartz/dartz.dart';
import 'package:metamorphis/src/domain/_core/exception/domain_exception.dart';
import 'package:metamorphis/src/domain/application/entities/application.dart';
import 'package:metamorphis/src/domain/bounded_context/entities/bounded_context.dart';
import 'package:metamorphis/src/domain/bounded_context/repositories/bounded_context_repository.dart';

class GetBoundedContextsByApplicationUseCase {
  late final BoundedContextRepository _boundedContextRepository;

  GetBoundedContextsByApplicationUseCase({
    required BoundedContextRepository boundedContextRepository,
  }) {
    _boundedContextRepository = boundedContextRepository;
  }

  Future<Either<DomainException, List<BoundedContext>>> execute(
    Application application,
  ) async {
    try {
      final result = await _boundedContextRepository.getByApplication(
        application.id,
      );
      return Right(result);
    } on DomainException catch (e) {
      return Left(e);
    } catch (e, s) {
      return Left(
        DomainException.of(
          message: e.toString(),
          trace: s.toString(),
          context: 'GetBoundedContextsByApplicationUseCase',
        ),
      );
    }
  }
}*/
