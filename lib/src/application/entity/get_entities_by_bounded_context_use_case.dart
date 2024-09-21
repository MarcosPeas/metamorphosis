import 'package:dartz/dartz.dart';
import 'package:metamorphis/src/domain/_core/exception/domain_exception.dart';
import 'package:metamorphis/src/domain/bounded_context/entities/bounded_context.dart';
import 'package:metamorphis/src/domain/entity/entities/entity.dart';
import 'package:metamorphis/src/domain/entity/repositories/entity_repository.dart';

class GetEntitiesByBoundedContextUseCase {
  late final EntityRepository _entityRepository;

  GetEntitiesByBoundedContextUseCase({
    required EntityRepository entityRepository,
  }) {
    _entityRepository = entityRepository;
  }

  Future<Either<DomainException, List<Entity>>> execute(
    BoundedContext boundedContext,
  ) async {
    try {
      final result = await _entityRepository.getByBoundedContext(
        boundedContext.id,
      );
      return Right(result);
    } on DomainException catch (e) {
      return Left(e);
    } catch (e, s) {
      return Left(
        DomainException.of(
          message: e.toString(),
          trace: s.toString(),
          context: 'GetEntitiesByBoundedContextUseCase',
        ),
      );
    }
  }
}
