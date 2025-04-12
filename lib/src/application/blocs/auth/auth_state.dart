part of 'auth_bloc.dart';

@immutable
sealed class AuthState {
  const factory AuthState.initial() = AuthInitial;
  const factory AuthState.authenticated() = AuthAuthenticated;
  const factory AuthState.unauthenticated() = AuthUnauthenticated;
  const factory AuthState.error(String message) = AuthError;
}

final class AuthInitial implements AuthState {
  const AuthInitial();
}

final class AuthAuthenticated implements AuthState {
  const AuthAuthenticated();
}

final class AuthUnauthenticated implements AuthState {
  const AuthUnauthenticated();
}

final class AuthError implements AuthState {
  final String message;
  const AuthError(this.message);
}
