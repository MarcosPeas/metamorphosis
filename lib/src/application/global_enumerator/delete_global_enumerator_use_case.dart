import 'package:dartz/dartz.dart';
import 'package:metamorphis/src/domain/_core/exception/domain_exception.dart';
import 'package:metamorphis/src/domain/global_enumerator/entities/global_enumerator.dart';
import 'package:metamorphis/src/domain/global_enumerator/repositories/global_enumerator_repository.dart';

class DeleteGlobalEnumeratorUseCase {
  late final GlobalEnumeratorRepository _repository;

  DeleteGlobalEnumeratorUseCase({
    required GlobalEnumeratorRepository repository,
  }) {
    _repository = repository;
  }

  Future<Either<DomainException, Unit>> execute(
    GlobalEnumerator enumerator,
  ) async {
    try {
      await _repository.delete(enumerator);
      return const Right(unit);
    } on DomainException catch (e) {
      return Left(e);
    } catch (e, s) {
      return Left(
        DomainException.of(
          message: e.toString(),
          trace: s.toString(),
          context: 'DeleteGlobalEnumeratorUseCase',
        ),
      );
    }
  }
}
