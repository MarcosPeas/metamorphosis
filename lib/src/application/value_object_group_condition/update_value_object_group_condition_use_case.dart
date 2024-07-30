import 'package:dartz/dartz.dart';
import 'package:metamorphis/src/domain/_core/exception/domain_exception.dart';
import 'package:metamorphis/src/domain/value_object_group_condition/entities/value_object_group_condition.dart';
import 'package:metamorphis/src/domain/value_object_group_condition/repositories/value_object_group_condition_repository.dart';

class UpdateValueObjectGroupConditionUseCase {
  late final ValueObjectGroupConditionRepository
      _valueObjectGroupConditionRepository;

  UpdateValueObjectGroupConditionUseCase({
    required ValueObjectGroupConditionRepository
        valueObjectGroupConditionRepository,
  }) {
    _valueObjectGroupConditionRepository = valueObjectGroupConditionRepository;
  }

  Future<Either<DomainException, ValueObjectGroupCondition>> execute(
    ValueObjectGroupCondition valueObjectGroupCondition,
  ) async {
    try {
      final result = await _valueObjectGroupConditionRepository
          .update(valueObjectGroupCondition);
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
