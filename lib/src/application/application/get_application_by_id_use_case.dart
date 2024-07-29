import 'package:dartz/dartz.dart';
import 'package:metamorphis/src/domain/_core/exception/domain_exception.dart';
import 'package:metamorphis/src/domain/application/entities/application.dart';
import 'package:metamorphis/src/domain/application/repositories/application_repository.dart';

class GetApplicationByIdUseCase {
  late final ApplicationRepository _applicationRepository;

  GetApplicationByIdUseCase({
    required ApplicationRepository applicationRepository,
  }) {
    _applicationRepository = applicationRepository;
  }

  Future<Either<DomainException, Application>> execute(
    String id
  ) async {
    try {
      final result = await _applicationRepository.getById(id);
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
