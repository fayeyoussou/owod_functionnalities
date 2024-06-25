import 'package:owod_functionnalities/core/error/failure.dart';
import 'package:owod_functionnalities/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/common/entities/user.dart';
import '../repositories/auth_repository.dart';

class CurrentUser implements UseCase<User, NoParams> {
  final AuthRepository authRepository;

  CurrentUser(this.authRepository);

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await authRepository.currentUser();
  }
}
