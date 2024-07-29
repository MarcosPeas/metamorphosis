import 'package:dartz/dartz.dart';
import 'package:metamorphis/src/domain/_core/exception/domain_exception.dart';
import 'package:metamorphis/src/domain/entity/entities/entity.dart';
import 'package:metamorphis/src/domain/entity/repositories/entity_repository.dart';

class DeleteEntityUseCase {
  late final EntityRepository _entityRepository;

  DeleteEntityUseCase({
    required EntityRepository entityRepository,
  }) {
    _entityRepository = entityRepository;
  }

  Future<Either<DomainException, Unit>> execute(
    Entity entity,
  ) async {
    try {
      await _entityRepository.delete(entity.id);
      return const Right(unit);
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
