import 'package:dartz/dartz.dart';
import 'package:metamorphis/src/domain/_core/domain/repository.dart';
import 'package:metamorphis/src/domain/_core/exception/domain_exception.dart';
import 'package:metamorphis/src/domain/global_enumerator/entities/global_enumerator.dart';
import 'package:metamorphis/src/domain/global_enumerator/repositories/global_enumerator_repository.dart';

class GetGlobalEnumeratorsByApplicationUseCase {
  late final GlobalEnumeratorRepository _repository;

  GetGlobalEnumeratorsByApplicationUseCase({
    required GlobalEnumeratorRepository repository,
  }) {
    _repository = repository;
  }

  Future<Either<DomainException, List<GlobalEnumerator>>> execute(
    PaginateParams params,
  ) async {
    try {
      final result = await _repository.filter(params);
      return Right(result);
    } on DomainException catch (e) {
      return Left(e);
    } catch (e, s) {
      return Left(
        DomainException.of(
          message: e.toString(),
          trace: s.toString(),
          context: 'UpdateGlobalEnumeratorUseCase',
        ),
      );
    }
  }
}
