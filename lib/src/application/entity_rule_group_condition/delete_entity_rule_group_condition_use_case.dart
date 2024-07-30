import 'package:dartz/dartz.dart';
import 'package:metamorphis/src/domain/_core/exception/domain_exception.dart';
import 'package:metamorphis/src/domain/entity_rule_group_condition/entities/entity_rule_group_condition.dart';
import 'package:metamorphis/src/domain/entity_rule_group_condition/repositories/entity_rule_group_condition_repository.dart';

class DeleteEntityRuleGroupConditionUseCase {
  late final EntityRuleGroupConditionRepository
      _entityRuleGroupConditionRepository;

  DeleteEntityRuleGroupConditionUseCase({
    required EntityRuleGroupConditionRepository
        entityRuleGroupConditionRepository,
  }) {
    _entityRuleGroupConditionRepository = entityRuleGroupConditionRepository;
  }

  Future<Either<DomainException, Unit>> execute(
    EntityRuleGroupCondition entityRuleGroupCondition,
  ) async {
    try {
      await _entityRuleGroupConditionRepository.delete(
        entityRuleGroupCondition.id,
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
