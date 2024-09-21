import 'package:dartz/dartz.dart';
import 'package:metamorphis/src/domain/_core/exception/domain_exception.dart';
import 'package:metamorphis/src/domain/value_object_group_condition/entities/value_object_group_condition.dart';
import 'package:metamorphis/src/domain/value_object_group_condition/repositories/value_object_group_condition_repository.dart';

class GetValueObjectGroupConditionByIdUseCase {
  late final ValueObjectGroupConditionRepository
      _valueObjectGroupConditionRepository;

  GetValueObjectGroupConditionByIdUseCase({
    required ValueObjectGroupConditionRepository
        valueObjectGroupConditionRepository,
  }) {
    _valueObjectGroupConditionRepository = valueObjectGroupConditionRepository;
  }

  Future<Either<DomainException, ValueObjectGroupCondition>> execute(
    String id,
  ) async {
    try {
      final result = await _valueObjectGroupConditionRepository.getById(id);
      return Right(result);
    } on DomainException catch (e) {
      return Left(e);
    } catch (e, s) {
      return Left(
        DomainException.of(
          message: e.toString(),
          trace: s.toString(),
          context: 'GetValueObjectGroupConditionByIdUseCase',
        ),
      );
    }
  }
}
