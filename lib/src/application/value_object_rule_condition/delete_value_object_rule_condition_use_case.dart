import 'package:dartz/dartz.dart';
import 'package:metamorphis/src/domain/_core/exception/domain_exception.dart';
import 'package:metamorphis/src/domain/value_object_rule_condition/entities/value_object_rule_condition.dart';
import 'package:metamorphis/src/domain/value_object_rule_condition/repositories/value_object_rule_condition_repository.dart';

class DeleteValueObjectRuleConditionUseCase {
  late final ValueObjectRuleConditionRepository
      _valueObjectRuleConditionRepository;

  DeleteValueObjectRuleConditionUseCase({
    required ValueObjectRuleConditionRepository
        valueObjectRuleConditionRepository,
  }) {
    _valueObjectRuleConditionRepository = valueObjectRuleConditionRepository;
  }

  Future<Either<DomainException, Unit>> execute(
    ValueObjectRuleCondition valueObjectRuleCondition,
  ) async {
    try {
      await _valueObjectRuleConditionRepository.delete(
        valueObjectRuleCondition,
      );
      return const Right(unit);
    } on DomainException catch (e) {
      return Left(e);
    } catch (e, s) {
      return Left(
        DomainException.of(
          message: e.toString(),
          trace: s.toString(),
          context: 'DeleteValueObjectRuleConditionUseCase',
        ),
      );
    }
  }
}
