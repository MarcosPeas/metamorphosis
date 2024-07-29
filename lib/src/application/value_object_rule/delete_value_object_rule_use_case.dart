import 'package:dartz/dartz.dart';
import 'package:metamorphis/src/domain/_core/exception/domain_exception.dart';
import 'package:metamorphis/src/domain/value_object_rule/entities/value_object_rule.dart';
import 'package:metamorphis/src/domain/value_object_rule/repositories/value_object_rule_repository.dart';

class DeleteValueObjectRuleUseCase {
  late final ValueObjectRuleRepository _valueObjectRuleRepository;

  DeleteValueObjectRuleUseCase({
    required ValueObjectRuleRepository valueObjectRuleRepository,
  }) {
    _valueObjectRuleRepository = valueObjectRuleRepository;
  }

  Future<Either<DomainException, Unit>> execute(
    ValueObjectRule valueObjectRule,
  ) async {
    try {
      await _valueObjectRuleRepository.delete(valueObjectRule.id);
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
