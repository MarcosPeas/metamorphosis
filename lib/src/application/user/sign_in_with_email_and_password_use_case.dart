import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:metamorphis/src/domain/_core/exception/domain_exception.dart';
import 'package:metamorphis/src/domain/user/entities/user.dart';
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
      log(e.message);
      log(e.trace);
      return Left(e);
    } catch (e, s) {
      log('$e');
      log('$s');
      return Left(
        DomainException.of(
          message: e.toString(),
          trace: s.toString(),
          context: 'SignInWithEmailAndPasswordUseCase',
        ),
      );
    }
  }

  Future<User> _loadUser(String userId) async {
    return _userRepository.getUserById(userId);
  }
}
