import 'package:dartz/dartz.dart';
import 'package:metamorphis/src/domain/_core/domain/repository.dart';
import 'package:metamorphis/src/domain/_core/exception/domain_exception.dart';
import 'package:metamorphis/src/domain/application/entities/application.dart';
import 'package:metamorphis/src/domain/application/repositories/application_repository.dart';

class GetApplicationsByProjectUseCase {
  late final ApplicationRepository _applicationRepository;

  GetApplicationsByProjectUseCase({
    required ApplicationRepository applicationRepository,
  }) {
    _applicationRepository = applicationRepository;
  }

  Future<Either<DomainException, List<Application>>> execute(
    PaginateParams params,
  ) async {
    try {
      final result = await _applicationRepository.filter(params);
      return Right(result);
    } on DomainException catch (e) {
      return Left(e);
    } catch (e, s) {
      return Left(
        DomainException.of(
          message: e.toString(),
          trace: s.toString(),
          context: 'GetApplicationsByProjectUseCase',
        ),
      );
    }
  }
}
