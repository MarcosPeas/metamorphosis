import 'package:dartz/dartz.dart';
import 'package:metamorphis/src/domain/_core/exception/domain_exception.dart';
import 'package:metamorphis/src/domain/entity/entities/entity.dart';
import 'package:metamorphis/src/domain/entity/repositories/entity_repository.dart';

class UpdateEntitiesUseCase {
  late final EntityRepository _repository;

  UpdateEntitiesUseCase({required EntityRepository repository}) {
    _repository = repository;
  }

  Future<Either<DomainException, List<Entity>>> execute(List<Entity> entities) async {
    try {
      final result = await _repository.updateAll(entities);
      return Right(result);
    } on DomainException catch (e) {
      return Left(e);
    } catch (e, s) {
      return Left(
        DomainException.of(
          message: e.toString(),
          trace: s.toString(),
          context: 'UpdateEntitiesUseCase',
        ),
      );
    }
  }
}
