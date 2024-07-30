import 'package:dartz/dartz.dart';
import 'package:metamorphis/src/domain/_core/exception/domain_exception.dart';
import 'package:metamorphis/src/domain/entity_rule/entities/entity_rule.dart';
import 'package:metamorphis/src/domain/entity_rule/repositories/entity_rule_repository.dart';

class DeleteEntityRuleUseCase {
  late final EntityRuleRepository _entityRuleRepository;

  DeleteEntityRuleUseCase({
    required EntityRuleRepository entityRuleRepository,
  }) {
    _entityRuleRepository = entityRuleRepository;
  }

  Future<Either<DomainException, Unit>> execute(EntityRule entityRule) async {
    try {
      await _entityRuleRepository.delete(entityRule.id);
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
