part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthStarted extends AuthEvent {}

class AuthButtonClicked extends AuthEvent {
  final String username;
  final String password;

  const AuthButtonClicked(this.username, this.password);

  @override
  List<Object> get props => [username, password];
}

class AuthModeChangedClicked extends AuthEvent {}
