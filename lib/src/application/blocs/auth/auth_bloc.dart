import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      // emit(const AuthState.initial());
      // try {
      //   await loginUseCase.execute(event.email, event.password);
      //   emit(const AuthState.authenticated());
      // } catch (e) {
      //   emit(AuthState.error(e.toString()));
      // }
    });
  }
}
