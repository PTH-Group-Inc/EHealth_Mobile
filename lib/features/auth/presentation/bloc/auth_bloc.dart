import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginButtonSubmitted>(_loginButtonSubmitted);
  }

  Future<void> _loginButtonSubmitted(
    LoginButtonSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      // Simulate a network call for authentication
      await Future.delayed(const Duration(seconds: 2));

      // Here you would typically call your authentication repository
      // For demonstration, we assume the login is always successful
      emit(AuthAuthenticated());
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }
}
