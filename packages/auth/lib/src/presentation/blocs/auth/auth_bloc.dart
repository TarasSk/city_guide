import 'dart:async';

import 'package:auth/src/data/user.dart';
import 'package:auth/src/domain/auth_repository.dart';
import 'package:dependencies/dependencies.dart' hide User;

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(
          authRepository.getCurrentUser() == const User.empty()
              ? const AuthUnauthenticated()
              : AuthAuthenticated(authRepository.getCurrentUser()),
        ) {
    on<LoginWithEmailRequested>(_loginWithEmailRequested);
    on<LoginWithGoogleRequested>(_loginWithGoogleRequested);
    on<LoginWithFacebookRequested>(_loginWithFacebookRequested);
    on<LoginWithAppleRequested>(_loginWithAppleRequested);
    on<LoginWithPhoneRequested>(_loginWithPhoneRequested);
    on<LoginWithAnonymousRequested>(_loginWithAnonymousRequested);
    on<LogoutRequested>(_logoutRequested);
  }

  final AuthRepository _authRepository;

  FutureOr<void> _loginWithEmailRequested(
    LoginWithEmailRequested event,
    Emitter<AuthState> emit,
  ) {}

  FutureOr<void> _loginWithGoogleRequested(
    LoginWithGoogleRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthInitial());
    try {
      final user = await _authRepository.signInWithGoogle();
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  FutureOr<void> _loginWithFacebookRequested(
    LoginWithFacebookRequested event,
    Emitter<AuthState> emit,
  ) {}
  FutureOr<void> _loginWithAppleRequested(
    LoginWithAppleRequested event,
    Emitter<AuthState> emit,
  ) {}
  FutureOr<void> _loginWithPhoneRequested(
    LoginWithPhoneRequested event,
    Emitter<AuthState> emit,
  ) {}
  FutureOr<void> _loginWithAnonymousRequested(
    LoginWithAnonymousRequested event,
    Emitter<AuthState> emit,
  ) {}
  FutureOr<void> _logoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) {}
}
