part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginButtonSubmitted extends AuthEvent {
  final String identifier;
  final String password;

  const LoginButtonSubmitted({
    required this.identifier,
    required this.password,
  });

  @override
  List<Object> get props => [identifier, password];
}
