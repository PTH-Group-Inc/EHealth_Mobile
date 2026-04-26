import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:e_health/app/helper/validate_helper.dart';
import 'package:e_health/data/repository.dart';
import 'package:e_health/presentation/screens/change_password/cubit/change_password_state.dart';

@injectable
class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final Repository _repository;

  ChangePasswordCubit(this._repository) : super(const ChangePasswordState());

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    // Basic validation
    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      emit(
        state.copyWith(
          status: ChangePasswordStatus.failure,
          message: "Vui lòng nhập đầy đủ thông tin",
        ),
      );
      return;
    }

    // New password != Confirm password
    if (newPassword != confirmPassword) {
      emit(
        state.copyWith(
          status: ChangePasswordStatus.failure,
          message: "Mật khẩu xác nhận không khớp",
        ),
      );
      return;
    }

    // Password complexity check
    if (!ValidateHelper.isValidPasswordComplex(newPassword)) {
      emit(
        state.copyWith(
          status: ChangePasswordStatus.failure,
          message:
              "Mật khẩu phải dài ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt",
        ),
      );
      return;
    }

    emit(state.copyWith(status: ChangePasswordStatus.loading));

    final result = await _repository.changePassword(oldPassword, newPassword);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ChangePasswordStatus.failure,
          message: failure.message,
        ),
      ),
      (_) => emit(state.copyWith(status: ChangePasswordStatus.success)),
    );
  }

  void toggleObscureOld() =>
      emit(state.copyWith(obscureOldPassword: !state.obscureOldPassword));
  void toggleObscureNew() =>
      emit(state.copyWith(obscureNewPassword: !state.obscureNewPassword));
  void toggleObscureConfirm() => emit(
    state.copyWith(obscureConfirmPassword: !state.obscureConfirmPassword),
  );
}
