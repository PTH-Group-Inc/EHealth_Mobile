import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../data/repository.dart';
import 'verify_email_state.dart';

@injectable
class VerifyEmailCubit extends Cubit<VerifyEmailState> {
  final Repository _repository;

  VerifyEmailCubit(this._repository) : super(const VerifyEmailState());

  Future<void> verifyEmail(String email, String code) async {
    emit(state.copyWith(status: VerifyEmailStatus.loading));

    final result = await _repository.verifyEmail(email, code);

    result.fold(
      (failure) => emit(state.copyWith(
        status: VerifyEmailStatus.failure,
        message: failure.message,
      )),
      (_) => emit(state.copyWith(
        status: VerifyEmailStatus.success,
        message: "Xác thực email thành công!",
      )),
    );
  }
}
