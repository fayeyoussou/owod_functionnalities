import 'package:bloc/bloc.dart';
import 'package:owod_functionnalities/core/usecase/usecase.dart';
import 'package:owod_functionnalities/features/auth/data/models/user_model.dart';
import 'package:owod_functionnalities/core/common/entities/user.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meta/meta.dart';

import '../../../../core/common/cubits/app_user/app_user_cubit.dart';
import '../../../../core/error/failure.dart';
import '../../domain/usecases/current_user.dart';
import '../../domain/usecases/user_login.dart';
import '../../domain/usecases/user_sign_up.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;

  AuthBloc(
      {required UserSignUp userSignUp,
      required UserLogin userLogin,
      required CurrentUser currentUser,
      required AppUserCubit appUserCubit})
      : _userSignUp = userSignUp,
        _userLogin = userLogin,
        _currentUser = currentUser,
        _appUserCubit = appUserCubit,
        super(AuthInitial()) {
    on<AuthSignup>(_onAuthSignUp);
    on<AuthSignIn>(_onAuthLogin);
    on<AuthIsUserLoggedIn>(_onAuthIsUserLoggedIn);
  }

  Future<void> _performAuthAction(
      Future<Either<Failure, User>> Function() action,
      Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await action();
    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) {
        _appUserCubit.updateUser(user);
        emit(AuthSuccess(user));
      },
    );
  }

  void _onAuthSignUp(AuthSignup event, Emitter<AuthState> emit) async {
    await _performAuthAction(
      () => _userSignUp(UserSignUpParams(
          email: event.email, password: event.password, name: event.name)),
      emit,
    );
  }

  void _onAuthLogin(AuthSignIn event, Emitter<AuthState> emit) async {
    await _performAuthAction(
      () => _userLogin(
          UserLoginParams(email: event.email, password: event.password)),
      emit,
    );
  }

  void _onAuthIsUserLoggedIn(
      AuthIsUserLoggedIn event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _currentUser(NoParams());
    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) {
        _appUserCubit.updateUser(user);
        emit(AuthSuccess(user));
      },
    );
  }
}
