import 'package:e_health/features/auth/data/auth_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthApi _api;

  AuthCubit(this._api) : super(AuthState());

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
      final success = await _api.login(email, password);
      if (success != null) {
        emit(state.copyWith(status: AuthStatus.success));
      } else {
        emit(
          state.copyWith(
            status: AuthStatus.failure,
            generalError: "Email hoặc mật khẩu không chính xác",
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          generalError: "Đã xảy ra lỗi, vui lòng thử lại sau",
        ),
      );
    }
  }

  Future<void> logout() async {
    emit(state.copyWith(status: AuthStatus.loading));
    await _api.logout();
    emit(state.copyWith(status: AuthStatus.initial));
  }

  Future<void> checkAuthStatus() async {
    final hasToken = await _api.hasToken();
    if (hasToken) {
      final userName = await _api.getStoredUserName();
      emit(state.copyWith(status: AuthStatus.success, userName: userName));
    } else {
      emit(state.copyWith(status: AuthStatus.initial));
    }
  }

  void toggleObscurePassword() {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }
}
