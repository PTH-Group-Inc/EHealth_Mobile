enum AuthStatus { initial, loading, success, failure }

class AuthState {
  final AuthStatus status;
  final String? emailError;
  final String? passwordError;
  final String? generalError;
  final bool obscurePassword;
  final String? userName;
  final String? userId;

  const AuthState({
    this.status = AuthStatus.initial,
    this.emailError,
    this.passwordError,
    this.generalError,
    this.obscurePassword = true,
    this.userName,
    this.userId,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? emailError,
    String? passwordError,
    String? generalError,
    bool? obscurePassword,
    String? userName,
    String? userId,
  }) {
    return AuthState(
      status: status ?? this.status,
      emailError: emailError,
      passwordError: passwordError,
      generalError: generalError,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      userName: userName ?? this.userName,
      userId: userId ?? this.userId,
    );
  }
}
