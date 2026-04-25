import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:e_health/presentation/screens/home/screens/cubit/navigation_cubit.dart';
import 'package:e_health/app/helper/validate_helper.dart';
import 'package:e_health/data/repository.dart';
import 'package:e_health/presentation/screens/auth/cubit/auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  final Repository _repository;
  final NavigationCubit _navigationCubit;

  AuthCubit(this._repository, this._navigationCubit) : super(AuthState());

  Future<void> login(String input, String password) async {
    if (input.isEmpty) {
      emit(
        state.copyWith(emailError: "Vui lòng nhập email hoặc số điện thoại"),
      );
      return;
    }
    if (password.isEmpty) {
      emit(state.copyWith(passwordError: "Vui lòng nhập mật khẩu"));
      return;
    }

    emit(state.copyWith(status: AuthStatus.loading));

    final normalizedPhone = ValidateHelper.normalizePhone(input);
    bool isEmail = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(input);
    bool isValidPhone = ValidateHelper.isValidPhone(input);

    final result = isValidPhone
        ? await _repository.loginPhone(normalizedPhone, password)
        : isEmail
        ? await _repository.login(input, password)
        : null;

    if (result == null) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          emailError:
              "Email hoặc số điện thoại không hợp lệ (Số điện thoại phải bắt đầu bằng 03, 05, 07, 08, 09 và có đủ 10 chữ số)",
        ),
      );
      return;
    }

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AuthStatus.failure,
          generalError: failure.message,
        ),
      ),
      (user) =>
          emit(state.copyWith(status: AuthStatus.success, userName: user.name)),
    );
  }

  Future<void> logout() async {
    emit(state.copyWith(status: AuthStatus.loading));
    await _repository.logout();
    _navigationCubit.reset();
    emit(state.copyWith(status: AuthStatus.initial, userName: null));
  }

  Future<void> updateUserInfo(String name) async {
    await _repository.updateStoredUserName(name);
    emit(state.copyWith(userName: name));
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
