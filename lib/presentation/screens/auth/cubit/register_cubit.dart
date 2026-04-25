import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:e_health/app/helper/validate_helper.dart';
import 'package:e_health/data/repository.dart';
import 'package:e_health/presentation/screens/auth/cubit/register_state.dart';

@injectable
class RegisterCubit extends Cubit<RegisterState> {
  final Repository _repository;

  RegisterCubit(this._repository) : super(const RegisterState());

  Future<void> register({
    required String phone,
    required String name,
    required String password,
  }) async {
    bool hasError = false;
    String? phoneError;
    String? nameError;
    String? passwordError;

    if (phone.isEmpty) {
      phoneError = "Số điện thoại không được để trống";
      hasError = true;
    } else if (!ValidateHelper.isValidPhone(phone)) {
      phoneError = "Số điện thoại không hợp lệ (phải bắt đầu bằng 03, 05, 07, 08, 09 và có đủ 10 chữ số)";
      hasError = true;
    }

    if (name.isEmpty) {
      nameError = "Họ và tên không được để trống";
      hasError = true;
    }

    if (password.isEmpty) {
      passwordError = "Mật khẩu không được để trống";
      hasError = true;
    } else if (password.length < 6) {
      passwordError = "Mật khẩu phải có ít nhất 6 ký tự";
      hasError = true;
    }

    if (hasError) {
      emit(state.copyWith(
        phoneError: phoneError,
        nameError: nameError,
        passwordError: passwordError,
      ));
      return;
    }

    emit(state.copyWith(status: RegisterStatus.loading));

    final normalizedPhone = ValidateHelper.normalizePhone(phone);
    final result = await _repository.registerPhone(normalizedPhone, password, name);

    result.fold(
      (failure) => emit(state.copyWith(
        status: RegisterStatus.failure,
        message: failure.message,
      )),
      (_) async {
        // Auto login after registration
        final loginResult =
            await _repository.loginPhone(normalizedPhone, password);
        loginResult.fold(
          (failure) => emit(state.copyWith(
            status: RegisterStatus.success, // Still registered, but login failed
            message: "Đăng ký thành công! Vui lòng đăng nhập lại.",
          )),
          (user) => emit(state.copyWith(
            status: RegisterStatus.success,
            message: "Đăng ký và đăng nhập thành công!",
          )),
        );
      },
    );
  }

  void toggleRegisterMode(bool isEmailMode) {
    emit(state.copyWith(
      isEmailMode: isEmailMode,
      phoneError: null,
      emailError: null,
      nameError: null,
      passwordError: null,
      status: RegisterStatus.initial,
    ));
  }

  Future<void> registerEmail({
    required String email,
    required String name,
    required String password,
  }) async {
    bool hasError = false;
    String? emailError;
    String? nameError;
    String? passwordError;

    if (email.isEmpty) {
      emailError = "Email không được để trống";
      hasError = true;
    } else if (!ValidateHelper.isValidEmail(email)) {
      emailError = "Email không hợp lệ";
      hasError = true;
    }

    if (name.isEmpty) {
      nameError = "Họ và tên không được để trống";
      hasError = true;
    }

    if (password.isEmpty) {
      passwordError = "Mật khẩu không được để trống";
      hasError = true;
    } else if (password.length < 6) {
      passwordError = "Mật khẩu phải có ít nhất 6 ký tự";
      hasError = true;
    }

    if (hasError) {
      emit(state.copyWith(
        emailError: emailError,
        nameError: nameError,
        passwordError: passwordError,
        phoneError: null, // Clear other errors
      ));
      return;
    }

    emit(state.copyWith(
      status: RegisterStatus.loading,
      emailError: null,
      nameError: null,
      passwordError: null,
      phoneError: null,
    ));

    final result = await _repository.registerEmail(email, password, name);

    result.fold(
      (failure) => emit(state.copyWith(
        status: RegisterStatus.failure,
        message: failure.message,
      )),
      (_) async {
        final loginResult = await _repository.login(email, password);
        loginResult.fold(
          (failure) => emit(state.copyWith(
            status: RegisterStatus.success,
            message: "Đăng ký thành công! Vui lòng đăng nhập lại.",
          )),
          (user) => emit(state.copyWith(
            status: RegisterStatus.success,
            message: "Đăng ký và đăng nhập thành công!",
          )),
        );
      },
    );
  }
}
