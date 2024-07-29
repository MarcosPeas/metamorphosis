import 'package:dartz/dartz.dart';
import 'package:metamorphis/src/domain/_core/exception/domain_exception.dart';
import 'package:metamorphis/src/domain/value_object/entities/value_object.dart';
import 'package:metamorphis/src/domain/value_object_rule/entities/value_object_rule.dart';
import 'package:metamorphis/src/domain/value_object_rule/repositories/value_object_rule_repository.dart';

class GetValueObjectRuleByApplicationUseCase {
  late final ValueObjectRuleRepository _valueObjectRuleRepository;

  GetValueObjectRuleByApplicationUseCase({
    required ValueObjectRuleRepository valueObjectRuleRepository,
  }) {
    _valueObjectRuleRepository = valueObjectRuleRepository;
  }

  Future<Either<DomainException, List<ValueObjectRule>>> execute(
    ValueObject valueObject,
  ) async {
    try {
      final result = await _valueObjectRuleRepository.getByValueObject(
        valueObject.id,
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
