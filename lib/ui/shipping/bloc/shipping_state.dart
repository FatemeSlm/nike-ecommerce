part of 'shipping_bloc.dart';

abstract class ShippingState extends Equatable {
  const ShippingState();

  @override
  List<Object> get props => [];
}

class ShippingInitial extends ShippingState {}

class ShippingLoading extends ShippingState {}

class ShippingError extends ShippingState {
  final AppException appException;

  const ShippingError(this.appException);

  @override
  List<Object> get props => [appException];
}

class ShippingSuccess extends ShippingState {
  final CreateOrderResponse response;

  const ShippingSuccess(this.response);

  @override
  List<Object> get props => [response];
}
