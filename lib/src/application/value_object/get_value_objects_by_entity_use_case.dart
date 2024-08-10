import 'package:dartz/dartz.dart';
import 'package:metamorphis/src/domain/_core/exception/domain_exception.dart';
import 'package:metamorphis/src/domain/entity/entities/entity.dart';
import 'package:metamorphis/src/domain/value_object/entities/value_object.dart';
import 'package:metamorphis/src/domain/value_object/repositories/value_object_repository.dart';

class GetValueObjectsByEntityUseCase {
  late final ValueObjectRepository _valueObjectRepository;

  GetValueObjectsByEntityUseCase({
    required ValueObjectRepository valueObjectRepository,
  }) {
    _valueObjectRepository = valueObjectRepository;
  }

  Future<Either<DomainException, List<ValueObject>>> execute(
    Entity entity,
  ) async {
    try {
      final result = await _valueObjectRepository.getByEntity(
        entity.id,
      );
      return Right(result);
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
