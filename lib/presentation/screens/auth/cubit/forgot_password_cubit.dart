import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../data/repository.dart';
import 'forgot_password_state.dart';

@injectable
class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final Repository _repository;

  ForgotPasswordCubit(this._repository) : super(const ForgotPasswordState());

  Future<void> sendForgotPasswordEmail(String email) async {
    emit(state.copyWith(status: ForgotPasswordStatus.loading));
    final result = await _repository.forgotPassword(email);

    result.fold(
      (failure) => emit(state.copyWith(
        status: ForgotPasswordStatus.failure,
        message: failure.message,
      )),
      (_) => emit(state.copyWith(
        status: ForgotPasswordStatus.success,
        email: email,
        isEmailSent: true,
      )),
    );
  }

  Future<void> resetPassword(String otp, String newPassword) async {
    emit(state.copyWith(status: ForgotPasswordStatus.loading));
    final result = await _repository.resetPassword(otp, newPassword);

    result.fold(
      (failure) => emit(state.copyWith(
        status: ForgotPasswordStatus.failure,
        message: failure.message,
      )),
      (_) => emit(state.copyWith(
        status: ForgotPasswordStatus.success,
        isResetSuccess: true,
      )),
    );
  }

  void resetState() {
    emit(const ForgotPasswordState());
  }
}
