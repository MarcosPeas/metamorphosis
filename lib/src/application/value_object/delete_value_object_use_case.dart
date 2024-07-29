import 'package:dartz/dartz.dart';
import 'package:metamorphis/src/domain/_core/exception/domain_exception.dart';
import 'package:metamorphis/src/domain/value_object/entities/value_object.dart';
import 'package:metamorphis/src/domain/value_object/repositories/value_object_repository.dart';

class DeleteValueObjectUseCase {
  late final ValueObjectRepository _valueObjectRepository;

  DeleteValueObjectUseCase({
    required ValueObjectRepository valueObjectRepository,
  }) {
    _valueObjectRepository = valueObjectRepository;
  }

  Future<Either<DomainException, Unit>> execute(
    ValueObject valueObject,
  ) async {
    try {
      await _valueObjectRepository.delete(valueObject.id);
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
