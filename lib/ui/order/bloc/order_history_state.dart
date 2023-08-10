part of 'order_history_bloc.dart';

abstract class OrderHistoryState extends Equatable {
  const OrderHistoryState();

  @override
  List<Object> get props => [];
}

class OrderHistoryLoading extends OrderHistoryState {}

class OrderHistorySuccess extends OrderHistoryState {
  final List<OrderEntity> orderList;

  const OrderHistorySuccess(this.orderList);

  @override
  List<Object> get props => [orderList];
}

class OrderHistoryError extends OrderHistoryState {
  final AppException appException;

  const OrderHistoryError(this.appException);

  @override
  List<Object> get props => [appException];
}
