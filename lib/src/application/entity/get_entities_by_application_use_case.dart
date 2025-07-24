import 'package:dartz/dartz.dart';
import 'package:metamorphis/src/domain/_core/domain/repository.dart';
import 'package:metamorphis/src/domain/_core/exception/domain_exception.dart';
import 'package:metamorphis/src/domain/entity/entities/entity.dart';
import 'package:metamorphis/src/domain/entity/repositories/entity_repository.dart';

class GetEntitiesByApplicationUseCase {
  late final EntityRepository _entityRepository;

  GetEntitiesByApplicationUseCase({
    required EntityRepository entityRepository,
  }) {
    _entityRepository = entityRepository;
  }

  Future<Either<DomainException, List<Entity>>> execute(
    PaginateParams params,
  ) async {
    try {
      final result = await _entityRepository.paginate(params);
      return Right(result);
    } on DomainException catch (e) {
      return Left(e);
    } catch (e, s) {
      return Left(
        DomainException.of(
          message: e.toString(),
          trace: s.toString(),
          context: 'GetEntitiesByApplicationUseCase',
        ),
      );
    }
  }
}
