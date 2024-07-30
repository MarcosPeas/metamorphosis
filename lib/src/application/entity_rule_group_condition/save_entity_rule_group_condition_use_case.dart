import 'package:dartz/dartz.dart';
import 'package:metamorphis/src/domain/_core/exception/domain_exception.dart';
import 'package:metamorphis/src/domain/entity_rule_group_condition/entities/entity_rule_group_condition.dart';
import 'package:metamorphis/src/domain/entity_rule_group_condition/repositories/entity_rule_group_condition_repository.dart';

class SaveEntityRuleGroupConditionUseCase {
  late final EntityRuleGroupConditionRepository
      _entityRuleGroupConditionRepository;

  SaveEntityRuleGroupConditionUseCase({
    required EntityRuleGroupConditionRepository
        entityRuleGroupConditionRepository,
  }) {
    _entityRuleGroupConditionRepository = entityRuleGroupConditionRepository;
  }

  Future<Either<DomainException, EntityRuleGroupCondition>> execute(
    EntityRuleGroupCondition entityRuleGroupCondition,
  ) async {
    try {
      final result = await _entityRuleGroupConditionRepository.save(
        entityRuleGroupCondition,
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
