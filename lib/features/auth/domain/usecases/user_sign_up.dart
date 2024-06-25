import 'package:owod_functionnalities/core/error/failure.dart';
import 'package:owod_functionnalities/core/usecase/usecase.dart';
import 'package:owod_functionnalities/core/common/entities/user.dart';
import 'package:owod_functionnalities/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/src/either.dart';

class UserSignUp implements UseCase<User, UserSignUpParams> {
  final AuthRepository authRepository;

  UserSignUp(this.authRepository);
  @override
  Future<Either<Failure, User>> call(UserSignUpParams params) async {
    return await authRepository.signupWithEmailPassword(
        email: params.email, name: params.name, password: params.password);
  }
}

class UserSignUpParams {
  final String email;
  final String password;
  final String name;

  UserSignUpParams(
      {required this.email, required this.password, required this.name});
}
