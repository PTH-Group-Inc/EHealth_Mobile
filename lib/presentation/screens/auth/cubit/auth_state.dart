enum AuthStatus { initial, loading, success, failure }

class AuthState {
  final AuthStatus status;
  final String? emailError;
  final String? passwordError;
  final String? generalError;
  final bool obscurePassword;
  final String? userName;

  const AuthState({
    this.status = AuthStatus.initial,
    this.emailError,
    this.passwordError,
    this.generalError,
    this.obscurePassword = true,
    this.userName,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? emailError,
    String? passwordError,
    String? generalError,
    bool? obscurePassword,
    String? userName,
  }) {
    return AuthState(
      status: status ?? this.status,
      emailError: emailError,
      passwordError: passwordError,
      generalError: generalError,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      userName: userName ?? this.userName,
    );
  }
}
