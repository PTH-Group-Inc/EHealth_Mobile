import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
  }

  void _onLoginRequested(AuthLoginRequested event, Emitter<AuthState> emit) async {
    final email = event.email;
    final password = event.password;

    // 1. Validate Email
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      return emit(AuthFailure(emailError: "Email không đúng định dạng!"));
    }

    // 2. Validate Password
    if (password.length < 6) {
      return emit(AuthFailure(passwordError: "Mật khẩu phải từ 6 ký tự trở lên!"));
    }

    // Ký tự đặc biệt regex
    final specialCharRegex = RegExp(r'[!@#$%^&*(),.?":{}|<> ]');
    if (!specialCharRegex.hasMatch(password)) {
      return emit(AuthFailure(passwordError: "Mật khẩu phải chứa ít nhất 1 ký tự đặc biệt!"));
    }

    // 3. Giả lập gọi API
    emit(AuthLoading());
    
    await Future.delayed(const Duration(seconds: 1)); // Giả lập delay

    // Giả lập thành công (Bạn có thể thêm logic kiểm tra tài khoản thực tế ở đây)
    emit(AuthSuccess());
  }
}
