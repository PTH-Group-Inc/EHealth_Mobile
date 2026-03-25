import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../data/repository.dart';
import 'auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  final Repository _repository;

  AuthCubit(this._repository) : super(AuthState());

  Future<void> login(String email, String password) async {
    if (email.isEmpty) {
      emit(state.copyWith(emailError: "Vui lòng nhập email"));
      return;
    }
    if (password.isEmpty) {
      emit(state.copyWith(passwordError: "Vui lòng nhập mật khẩu"));
      return;
    }

    emit(state.copyWith(status: AuthStatus.loading));

    try {
      final user = await _repository.login(email, password);
      emit(state.copyWith(
        status: AuthStatus.success,
        userName: user['name'],
      ));
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          generalError: e.toString().replaceFirst("Exception: ", ""),
        ),
      );
    }
  }

  Future<void> logout() async {
    emit(state.copyWith(status: AuthStatus.loading));
    await _repository.logout();
    emit(state.copyWith(status: AuthStatus.initial, userName: null));
  }

  Future<void> checkAuthStatus() async {
    final hasToken = await _repository.hasToken();
    if (hasToken) {
      final userName = await _repository.getStoredUserName();
      emit(state.copyWith(
        status: AuthStatus.success,
        userName: userName,
      ));
    } else {
      emit(state.copyWith(status: AuthStatus.initial));
    }
  }

  void toggleObscurePassword() {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }
}
