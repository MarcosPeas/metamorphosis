import 'package:dartz/dartz.dart';
import 'package:metamorphis/src/domain/_core/exception/domain_exception.dart';
import 'package:metamorphis/src/domain/user/repositories/user_repository.dart';

class SignOutUseCase {
  late final UserRepository _userRepository;

  SignOutUseCase({required UserRepository userRepository}) {
    _userRepository = userRepository;
  }

  Future<Either<DomainException, Unit>> execute({
    required String email,
    required String password,
  }) async {
    try {
      await _userRepository.signOut();
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
