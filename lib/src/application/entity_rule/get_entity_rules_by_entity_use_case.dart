import 'package:dartz/dartz.dart';
import 'package:metamorphis/src/domain/_core/domain/repository.dart';
import 'package:metamorphis/src/domain/_core/exception/domain_exception.dart';
import 'package:metamorphis/src/domain/entity_rule/entities/entity_rule.dart';
import 'package:metamorphis/src/domain/entity_rule/repositories/entity_rule_repository.dart';

class GetEntityRulesByProjectUseCase {
  late final EntityRuleRepository _entityRuleRepository;

  GetEntityRulesByProjectUseCase({
    required EntityRuleRepository entityRuleRepository,
  }) {
    _entityRuleRepository = entityRuleRepository;
  }

  Future<Either<DomainException, List<EntityRule>>> execute(
    PaginateParams params,
  ) async {
    try {
      final result = await _entityRuleRepository.paginate(params);
      return Right(result);
    } on DomainException catch (e) {
      return Left(e);
    } catch (e, s) {
      return Left(
        DomainException.of(
          message: e.toString(),
          trace: s.toString(),
          context: 'GetEntityRulesByProjectUseCase',
        ),
      );
    }
  }
}
