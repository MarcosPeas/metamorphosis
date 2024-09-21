import 'package:dartz/dartz.dart';
import 'package:metamorphis/src/domain/_core/exception/domain_exception.dart';
import 'package:metamorphis/src/domain/value_object_rule/entities/value_object_rule.dart';
import 'package:metamorphis/src/domain/value_object_rule/repositories/value_object_rule_repository.dart';

class UpdateValueObjectRuleUseCase {
  late final ValueObjectRuleRepository _valueObjectRuleRepository;

  UpdateValueObjectRuleUseCase({
    required ValueObjectRuleRepository valueObjectRuleRepository,
  }) {
    _valueObjectRuleRepository = valueObjectRuleRepository;
  }

  Future<Either<DomainException, ValueObjectRule>> execute(
    ValueObjectRule valueObjectRule,
  ) async {
    try {
      final result = await _valueObjectRuleRepository.update(valueObjectRule);
      return Right(result);
    } on DomainException catch (e) {
      return Left(e);
    } catch (e, s) {
      return Left(
        DomainException.of(
          message: e.toString(),
          trace: s.toString(),
          context: 'UpdateValueObjectRuleUseCase',
        ),
      );
    }
  }
}
