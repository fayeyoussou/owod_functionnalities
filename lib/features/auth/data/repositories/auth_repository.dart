import 'package:owod_functionnalities/core/error/failure.dart';
import 'package:owod_functionnalities/core/error/server_exception.dart';
import 'package:owod_functionnalities/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:owod_functionnalities/features/auth/data/models/user_model.dart';
import 'package:owod_functionnalities/core/common/entities/user.dart';
import 'package:owod_functionnalities/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/src/either.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;

  const AuthRepositoryImpl(this.authRemoteDataSource);

  @override
  Future<Either<Failure, User>> loginWithEmailPassword(
      {required String email, required String password}) async {
    return await _getUser(() async => await authRemoteDataSource
        .loginWithEmailPassword(email: email, password: password));
  }

  @override
  Future<Either<Failure, User>> signupWithEmailPassword(
      {required String email,
      required String name,
      required String password}) async {
    return await _getUser(() async => await authRemoteDataSource
        .signUpWithEmailPassword(name: name, email: email, password: password));
  }

  Future<Either<Failure, User>> _getUser(Future<User> Function() func) async {
    try {
      final user = await func();
      return right(user);
    } on ServerException catch (exception) {
      return left(Failure(exception.message));
    }
  }

  @override
  Future<Either<Failure, User>> currentUser() async {
    try {
      final user = await authRemoteDataSource.getCurrentUserData();
      if (user == null) return left(Failure('user not logged in !'));
      return right(user);
    } on ServerException catch (exception) {
      return left(Failure(exception.message));
    }
  }
}
