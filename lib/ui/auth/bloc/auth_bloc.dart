import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_ecommerce/common/exceptions.dart';
import 'package:nike_ecommerce/data/repo/auth_repository.dart';
import 'package:nike_ecommerce/data/repo/cart_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  bool isLogin;
  final IAuthRepository repository;
  final CartRepository cartRepository;

  AuthBloc(this.repository, this.cartRepository, {this.isLogin = true})
      : super(AuthInitial(isLogin)) {
    on<AuthEvent>((event, emit) async {
      try {
        if (event is AuthButtonClicked) {
          emit(AuthLoading(isLogin));
          if (isLogin) {
            await repository.login(event.username, event.password);
            await cartRepository.count();
          } else {
            await repository.register(event.username, event.password);
          }
          emit(AuthSuccess(isLogin));
        } else if (event is AuthModeChangedClicked) {
          isLogin = !isLogin;
          emit(AuthInitial(isLogin));
        }
      } catch (e) {
        emit(AuthError(
          isLogin,
          AppException(),
        ));
      }
    });
  }
}
