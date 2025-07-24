import 'package:dartz/dartz.dart';
import 'package:metamorphis/src/domain/_core/domain/repository.dart';
import 'package:metamorphis/src/domain/_core/exception/domain_exception.dart';
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
    PaginateParams params,
  ) async {
    try {
      final result = await _valueObjectRuleRepository.paginate(params);
      return Right(result);
    } on DomainException catch (e) {
      return Left(e);
    } catch (e, s) {
      return Left(
        DomainException.of(
          message: e.toString(),
          trace: s.toString(),
          context: 'GetValueObjectRuleByApplicationUseCase',
        ),
      );
    }
  }
}
