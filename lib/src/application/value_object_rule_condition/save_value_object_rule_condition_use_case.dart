import 'package:dartz/dartz.dart';
import 'package:metamorphis/src/domain/_core/exception/domain_exception.dart';
import 'package:metamorphis/src/domain/value_object_rule_condition/entities/value_object_rule_condition.dart';
import 'package:metamorphis/src/domain/value_object_rule_condition/repositories/value_object_rule_condition_repository.dart';

class SaveValueObjectRuleConditionUseCase {
  late final ValueObjectRuleConditionRepository
      _valueObjectRuleConditionRepository;

  SaveValueObjectRuleConditionUseCase(
      {required ValueObjectRuleConditionRepository
          valueObjectRuleConditionRepository}) {
    _valueObjectRuleConditionRepository = valueObjectRuleConditionRepository;
  }

  Future<Either<DomainException, ValueObjectRuleCondition>> execute(
    ValueObjectRuleCondition valueObjectRuleCondition,
  ) async {
    try {
      final result = await _valueObjectRuleConditionRepository.save(
        valueObjectRuleCondition,
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
