part of 'product_bloc.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {}

class ProductAddToCartLoading extends ProductState {}

class ProductAddToCartError extends ProductState {
  final AppException exception;

  const ProductAddToCartError(this.exception);

  @override
  List<Object> get props => [exception];
}

class ProductAddToCartSuccess extends ProductState {
  final AddToCartResponse cartResponse;

  const ProductAddToCartSuccess(this.cartResponse);

  @override
  List<Object> get props => [cartResponse];
}
