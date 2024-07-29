import 'package:dartz/dartz.dart';
import 'package:metamorphis/src/domain/_core/exception/domain_exception.dart';
import 'package:metamorphis/src/domain/user/entities/user.dart';
import 'package:metamorphis/src/domain/user/repositories/user_repository.dart';

class SaveUserUseCase {
  late final UserRepository _userRepository;

  SaveUserUseCase({required UserRepository userRepository}) {
    _userRepository = userRepository;
  }

  Future<Either<DomainException, User>> execute(User user) async {
    try {
      final result = await _userRepository.save(user);
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
