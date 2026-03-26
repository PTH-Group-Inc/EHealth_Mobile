import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:e_health/presentation/screens/home/screens/cubit/navigation_cubit.dart';
import 'package:e_health/data/repository.dart';
import 'package:e_health/data/network/dio/failure.dart';
import 'package:e_health/presentation/screens/auth/cubit/auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  final Repository _repository;
  final NavigationCubit _navigationCubit;

  AuthCubit(this._repository, this._navigationCubit) : super(AuthState());

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
      emit(state.copyWith(status: AuthStatus.success, userName: user['name']));
    } catch (e) {
      String errorMessage = "Đã xảy ra lỗi, vui lòng thử lại sau";
      if (e is Failure) {
        errorMessage = e.message;
      } else {
        errorMessage = e.toString().replaceFirst("Exception: ", "");
      }

      emit(
        state.copyWith(status: AuthStatus.failure, generalError: errorMessage),
      );
    }
  }

  Future<void> logout() async {
    emit(state.copyWith(status: AuthStatus.loading));
    await _repository.logout();
    _navigationCubit.reset();
    emit(state.copyWith(status: AuthStatus.initial, userName: null));
  }

  Future<void> checkAuthStatus() async {
    final hasToken = await _repository.hasToken();
    if (hasToken) {
      final userName = await _repository.getStoredUserName();
      emit(state.copyWith(status: AuthStatus.success, userName: userName));
    } else {
      emit(state.copyWith(status: AuthStatus.initial));
    }
  }

  void toggleObscurePassword() {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }
}
