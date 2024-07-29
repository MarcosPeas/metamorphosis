import 'package:dartz/dartz.dart';
import 'package:metamorphis/src/domain/_core/exception/domain_exception.dart';
import 'package:metamorphis/src/domain/value_object_rule/entities/value_object_rule.dart';
import 'package:metamorphis/src/domain/value_object_rule/repositories/value_object_rule_repository.dart';

class GetValueObjectRuleByIdUseCase {
  late final ValueObjectRuleRepository _valueObjectRuleRepository;

  GetValueObjectRuleByIdUseCase({
    required ValueObjectRuleRepository valueObjectRuleRepository,
  }) {
    _valueObjectRuleRepository = valueObjectRuleRepository;
  }

  Future<Either<DomainException, ValueObjectRule>> execute(String id) async {
    try {
      final result = await _valueObjectRuleRepository.getById(id);
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
