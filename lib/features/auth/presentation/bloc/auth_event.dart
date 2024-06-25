part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthSignup extends AuthEvent {
  final String email, password, name;

  AuthSignup({required this.email, required this.password, required this.name});

}
final class AuthSignIn extends AuthEvent {
  final String email, password;

  AuthSignIn({required this.email, required this.password});

}
final class AuthIsUserLoggedIn extends AuthEvent {}