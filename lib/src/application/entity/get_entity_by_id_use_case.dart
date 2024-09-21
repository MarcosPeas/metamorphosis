import 'package:dartz/dartz.dart';
import 'package:metamorphis/src/domain/_core/exception/domain_exception.dart';
import 'package:metamorphis/src/domain/entity/entities/entity.dart';
import 'package:metamorphis/src/domain/entity/repositories/entity_repository.dart';

class GetEntityByIdUseCase {
  late final EntityRepository _entityRepository;

  GetEntityByIdUseCase({
    required EntityRepository entityRepository,
  }) {
    _entityRepository = entityRepository;
  }

  Future<Either<DomainException, Entity>> execute(String id) async {
    try {
      final result = await _entityRepository.getById(id);
      return Right(result);
    } on DomainException catch (e) {
      return Left(e);
    } catch (e, s) {
      return Left(
        DomainException.of(
          message: e.toString(),
          trace: s.toString(),
          context: 'GetEntityByIdUseCase',
        ),
      );
    }
  }
}
