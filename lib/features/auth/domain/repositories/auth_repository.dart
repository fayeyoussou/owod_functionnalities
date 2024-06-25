import 'package:owod_functionnalities/core/common/entities/user.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> signupWithEmailPassword(
      {required String email, required String name, required String password});
  Future<Either<Failure, User>> loginWithEmailPassword(
      {required String email, required String password});
  Future<Either<Failure, User>> currentUser();
}
