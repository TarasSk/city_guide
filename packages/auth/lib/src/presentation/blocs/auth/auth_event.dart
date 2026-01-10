part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent extends Equatable {
  const AuthEvent();
  const factory AuthEvent.loginWitEmailRequested({
    required String email,
    required String password,
  }) = LoginWithEmailRequested;

  const factory AuthEvent.loginWithGoogleRequested() = LoginWithGoogleRequested;
  const factory AuthEvent.loginWithFacebookRequested() = LoginWithFacebookRequested;
  const factory AuthEvent.loginWithAppleRequested() = LoginWithAppleRequested;
  const factory AuthEvent.loginWithPhoneRequested() = LoginWithPhoneRequested;
  const factory AuthEvent.loginWithAnonymousRequested() = LoginWithAnonymousRequested;

  const factory AuthEvent.logoutRequested() = LogoutRequested;

  @override
  List<Object?> get props => [];
}

final class LoginWithEmailRequested extends AuthEvent {

  const LoginWithEmailRequested({required this.email, required this.password});
  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

final class LoginWithGoogleRequested extends AuthEvent {
  const LoginWithGoogleRequested();
}
final class LoginWithFacebookRequested extends AuthEvent {
  const LoginWithFacebookRequested();
}
final class LoginWithAppleRequested extends AuthEvent {
  const LoginWithAppleRequested();
}
final class LoginWithPhoneRequested extends AuthEvent {
  const LoginWithPhoneRequested();
}

final class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}
final class LoginWithAnonymousRequested extends AuthEvent {
  const LoginWithAnonymousRequested();
}

