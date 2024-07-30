import 'package:dartz/dartz.dart';
import 'package:metamorphis/src/domain/_core/exception/domain_exception.dart';
import 'package:metamorphis/src/domain/value_object_group_condition/entities/value_object_group_condition.dart';
import 'package:metamorphis/src/domain/value_object_group_condition/repositories/value_object_group_condition_repository.dart';

class DeleteValueObjectGroupConditionUseCase {
  late final ValueObjectGroupConditionRepository
      _valueObjectGroupConditionRepository;

  DeleteValueObjectGroupConditionUseCase({
    required ValueObjectGroupConditionRepository
        valueObjectGroupConditionRepository,
  }) {
    _valueObjectGroupConditionRepository = valueObjectGroupConditionRepository;
  }

  Future<Either<DomainException, Unit>> execute(
    ValueObjectGroupCondition valueObjectGroupCondition,
  ) async {
    try {
      await _valueObjectGroupConditionRepository.delete(
        valueObjectGroupCondition.id,
      );
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
