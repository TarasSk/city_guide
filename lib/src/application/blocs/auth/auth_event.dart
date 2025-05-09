part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {

  const factory AuthEvent.loginRequested({
    required String email,
    required String password,
  }) = LoginRequested;

  const factory AuthEvent.logoutRequested() = LogoutRequested;
}

final class LoginRequested implements AuthEvent {
  final String email;
  final String password;

  const LoginRequested({required this.email, required this.password});
}

final class LogoutRequested implements AuthEvent {
  const LogoutRequested();
}
