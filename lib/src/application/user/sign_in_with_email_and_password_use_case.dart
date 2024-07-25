import 'package:dartz/dartz.dart';
import 'package:metamorphis/src/domain/_core/exception/domain_exception.dart';
import 'package:metamorphis/src/domain/user/entity/user.dart';
import 'package:metamorphis/src/domain/user/repositories/user_repository.dart';

class SignInWithEmailAndPasswordUseCase {
  late final UserRepository _userRepository;

  SignInWithEmailAndPasswordUseCase({required UserRepository userRepository}) {
    _userRepository = userRepository;
  }

  Future<Either<DomainException, User>> execute({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _userRepository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = await _loadUser(result.id);
      return Right(user);
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

  Future<User> _loadUser(String userId) async {
    return _userRepository.getUserById(userId);
  }
}
