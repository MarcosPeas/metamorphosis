import 'package:dartz/dartz.dart';
import 'package:metamorphis/src/domain/_core/exception/domain_exception.dart';
import 'package:metamorphis/src/domain/entity_rule/entities/entity_rule.dart';
import 'package:metamorphis/src/domain/entity_rule/repositories/entity_rule_repository.dart';

class UpdateEntityRuleUseCase {
  late final EntityRuleRepository _entityRuleRepository;

  UpdateEntityRuleUseCase({
    required EntityRuleRepository entityRuleRepository,
  }) {
    _entityRuleRepository = entityRuleRepository;
  }

  Future<Either<DomainException, EntityRule>> execute(
    EntityRule entityRule,
  ) async {
    try {
      final result = await _entityRuleRepository.update(entityRule);
      return Right(result);
    } on DomainException catch (e) {
      return Left(e);
    } catch (e, s) {
      return Left(
        DomainException.of(
          message: e.toString(),
          trace: s.toString(),
          context: 'UpdateEntityRuleUseCase',
        ),
      );
    }
  }
}
