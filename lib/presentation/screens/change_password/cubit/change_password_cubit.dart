import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:e_health/data/repository.dart';
import 'package:e_health/app/dependency_injection/configure_injectable.dart';
import 'change_password_state.dart';

@injectable
class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  static final _repository = getIt<Repository>();

  ChangePasswordCubit() : super(const ChangePasswordState());

  Future<void> changePassword({
    required String userId,
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    // Basic validation
    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      emit(state.copyWith(
        status: ChangePasswordStatus.failure,
        message: "Vui lòng nhập đầy đủ thông tin",
      ));
      return;
    }

    // New password != Confirm password
    if (newPassword != confirmPassword) {
      emit(state.copyWith(
        status: ChangePasswordStatus.failure,
        message: "Mật khẩu xác nhận không khớp",
      ));
      return;
    }

    // Length check
    if (newPassword.length < 6) {
      emit(state.copyWith(
        status: ChangePasswordStatus.failure,
        message: "Mật khẩu phải có ít nhất 6 ký tự",
      ));
      return;
    }

    // Special character check
    final specialCharRegExp = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
    if (!specialCharRegExp.hasMatch(newPassword)) {
      emit(state.copyWith(
        status: ChangePasswordStatus.failure,
        message: "Mật khẩu phải chứa ít nhất 1 ký tự đặc biệt",
      ));
      return;
    }

    emit(state.copyWith(status: ChangePasswordStatus.loading));

    final result = await _repository.changePassword(userId, oldPassword, newPassword);

    result.fold(
      (failure) => emit(state.copyWith(
        status: ChangePasswordStatus.failure,
        message: failure.message,
      )),
      (_) => emit(state.copyWith(status: ChangePasswordStatus.success)),
    );
  }

  void toggleObscureOld() =>
      emit(state.copyWith(obscureOldPassword: !state.obscureOldPassword));
  void toggleObscureNew() =>
      emit(state.copyWith(obscureNewPassword: !state.obscureNewPassword));
  void toggleObscureConfirm() =>
      emit(state.copyWith(obscureConfirmPassword: !state.obscureConfirmPassword));
}
