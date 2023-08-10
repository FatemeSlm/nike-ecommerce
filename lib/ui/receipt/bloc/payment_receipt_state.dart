part of 'payment_receipt_bloc.dart';

abstract class PaymentReceiptState extends Equatable {
  const PaymentReceiptState();

  @override
  List<Object> get props => [];
}

class PaymentReceiptLoading extends PaymentReceiptState {}

class PaymentReceiptSuccess extends PaymentReceiptState {
  final PaymentReceipt paymentReceipt;

  const PaymentReceiptSuccess(this.paymentReceipt);

  @override
  List<Object> get props => [paymentReceipt];
}

class PaymentReceiptError extends PaymentReceiptState {
  final AppException appException;

  const PaymentReceiptError(this.appException);

  @override
  List<Object> get props => [appException];
}
