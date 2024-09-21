import 'package:dartz/dartz.dart';
import 'package:metamorphis/src/domain/_core/exception/domain_exception.dart';
import 'package:metamorphis/src/domain/value_object/entities/value_object.dart';
import 'package:metamorphis/src/domain/value_object/repositories/value_object_repository.dart';

class GetValueObjectByIdUseCase {
  late final ValueObjectRepository _valueObjectRepository;

  GetValueObjectByIdUseCase({
    required ValueObjectRepository valueObjectRepository,
  }) {
    _valueObjectRepository = valueObjectRepository;
  }

  Future<Either<DomainException, ValueObject>> execute(String id) async {
    try {
      final result = await _valueObjectRepository.getById(id);
      return Right(result);
    } on DomainException catch (e) {
      return Left(e);
    } catch (e, s) {
      return Left(
        DomainException.of(
          message: e.toString(),
          trace: s.toString(),
          context: 'GetValueObjectByIdUseCase',
        ),
      );
    }
  }
}
