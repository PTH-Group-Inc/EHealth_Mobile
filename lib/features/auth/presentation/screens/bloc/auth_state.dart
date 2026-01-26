abstract class AuthState {}

class AuthInit extends AuthState{}
class AuthLoading extends AuthState{}
class AuthSuccess extends AuthState{}
class AuthFailure extends AuthState{
  final String messages;

  AuthFailure(this.messages);
}