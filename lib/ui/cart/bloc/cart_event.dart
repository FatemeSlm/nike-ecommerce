part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class CartStarted extends CartEvent {
  final AuthInfo? authInfo;
  final bool isRefreshing;

  const CartStarted(this.authInfo, {this.isRefreshing = false});
}

class CartAuthInfoChanged extends CartEvent {
  final AuthInfo? authInfo;

  const CartAuthInfoChanged(this.authInfo);
}

class CartDeleteButtonClicked extends CartEvent {
  final int cartItemId;

  const CartDeleteButtonClicked(this.cartItemId);

  @override
  List<Object> get props => [cartItemId];
}

class CartPlusButtonClicked extends CartEvent {
  final int cartItemId;

  const CartPlusButtonClicked(this.cartItemId);

  @override
  List<Object> get props => [cartItemId];
}

class CartMinusButtonClicked extends CartEvent {
  final int cartItemId;

  const CartMinusButtonClicked(this.cartItemId);

  @override
  List<Object> get props => [cartItemId];
}
