import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:domain/src/login_use_case.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;

  AuthBloc(this.loginUseCase) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(const AuthState.initial());
      try {
        await loginUseCase.execute(event.email, event.password);
        emit(const AuthState.authenticated());
      } catch (e) {
        emit(AuthState.error(e.toString()));
      }
    });
  }
}
