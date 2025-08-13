import 'package:dartz/dartz.dart';
import 'package:metamorphis/src/domain/_core/exception/domain_exception.dart';
import 'package:metamorphis/src/domain/application/entities/application.dart';
import 'package:metamorphis/src/domain/application/repositories/application_repository.dart';

class DeleteApplicationUseCase {
  late final ApplicationRepository _applicationRepository;

  DeleteApplicationUseCase({
    required ApplicationRepository applicationRepository,
  }) {
    _applicationRepository = applicationRepository;
  }

  Future<Either<DomainException, Unit>> execute(Application application) async {
    try {
      await _applicationRepository.delete(application);
      return const Right(unit);
    } on DomainException catch (e) {
      return Left(e);
    } catch (e, s) {
      return Left(
        DomainException.of(
          message: e.toString(),
          trace: s.toString(),
          context: 'DeleteApplicationUseCase',
        ),
      );
    }
  }
}
