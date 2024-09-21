import 'package:dartz/dartz.dart';
import 'package:metamorphis/src/domain/_core/exception/domain_exception.dart';
import 'package:metamorphis/src/domain/entity_rule/entities/entity_rule.dart';
import 'package:metamorphis/src/domain/entity_rule_group_condition/entities/entity_rule_group_condition.dart';
import 'package:metamorphis/src/domain/entity_rule_group_condition/repositories/entity_rule_group_condition_repository.dart';

class GetEntityRuleGroupConditionsByEntityRuleUseCase {
  late final EntityRuleGroupConditionRepository
      _entityRuleGroupConditionRepository;

  GetEntityRuleGroupConditionsByEntityRuleUseCase({
    required EntityRuleGroupConditionRepository
        entityRuleGroupConditionRepository,
  }) {
    _entityRuleGroupConditionRepository = entityRuleGroupConditionRepository;
  }

  Future<Either<DomainException, List<EntityRuleGroupCondition>>> execute(
    EntityRule entityRule,
  ) async {
    try {
      final result = await _entityRuleGroupConditionRepository.getByEntityRule(
        entityRule.id,
      );
      return Right(result);
    } on DomainException catch (e) {
      return Left(e);
    } catch (e, s) {
      return Left(
        DomainException.of(
          message: e.toString(),
          trace: s.toString(),
          context: 'GetEntityRuleGroupConditionsByEntityRuleUseCase',
        ),
      );
    }
  }
}
