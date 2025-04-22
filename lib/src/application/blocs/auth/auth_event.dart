part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class LoginRequested implements AuthEvent {
  final String email;
  final String password;

  const LoginRequested({required this.email, required this.password});
}
