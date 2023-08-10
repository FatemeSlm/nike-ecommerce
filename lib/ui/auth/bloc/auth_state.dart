part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState(this.isLogin);

  final bool isLogin;
  
  @override
  List<Object> get props => [isLogin];
}

class AuthInitial extends AuthState {
 const AuthInitial(bool isLogin) : super(isLogin);
}

class AuthError extends AuthState{
  final AppException exception;
  const AuthError(bool isLogin, this.exception) : super(isLogin);

  @override
  
  List<Object> get props => [exception];

}

class AuthSuccess extends AuthState{
  const AuthSuccess(bool isLogin) : super(isLogin);

}

class AuthLoading extends AuthState{
  const AuthLoading(bool isLogin) : super(isLogin);

}
