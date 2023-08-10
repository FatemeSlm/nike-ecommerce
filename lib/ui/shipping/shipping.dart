import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_ecommerce/data/order.dart';
import 'package:nike_ecommerce/data/repo/order_repository.dart';
import 'package:nike_ecommerce/ui/cart/price_info.dart';
import 'package:nike_ecommerce/ui/payment_webview.dart';
import 'package:nike_ecommerce/ui/receipt/receipt.dart';
import 'package:nike_ecommerce/ui/shipping/bloc/shipping_bloc.dart';

class ShippingScreen extends StatefulWidget {
  final int payablePrice;
  final int shippingCost;
  final int totalPrice;

  const ShippingScreen(
      {Key? key,
      required this.payablePrice,
      required this.shippingCost,
      required this.totalPrice})
      : super(key: key);

  @override
  State<ShippingScreen> createState() => _ShippingScreenState();
}

class _ShippingScreenState extends State<ShippingScreen> {
  final TextEditingController firstNameController =
      TextEditingController(text: 'فاطمه');

  final TextEditingController lastNameController =
      TextEditingController(text: 'سلامه');

  final TextEditingController phoneNumberController =
      TextEditingController(text: '09121234567');

  final TextEditingController postalCodeController =
      TextEditingController(text: '1234567890');

  final TextEditingController addressController =
      TextEditingController(text: 'تهران خیایان شریعتی پلاک 2');

  StreamSubscription? subscription;

  @override
  void dispose() {
    subscription?.cancel();
    addressController.dispose();
    postalCodeController.dispose();
    phoneNumberController.dispose();
    lastNameController.dispose();
    firstNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('تحویل گیرنده')),
      body: BlocProvider<ShippingBloc>(
        create: (context) {
          final bloc = ShippingBloc(orderRepository);

          subscription = bloc.stream.listen((state) {
            if (state is ShippingError) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.appException.message)));
            } else if (state is ShippingSuccess) {
              if (state.response.bankGatewayUrl.isNotEmpty) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: ((context) => PaymentGatewayScreen(
                        bankGatewayUrl: state.response.bankGatewayUrl))));
              } else {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: ((context) => ReceiptScreen(
                          orderId: state.response.orderId,
                        ))));
              }
            }
          });

          return bloc;
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 54,
                child: TextField(
                  controller: firstNameController,
                  decoration: const InputDecoration(
                    label: Text('نام'),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              SizedBox(
                height: 54,
                child: TextField(
                  controller: lastNameController,
                  decoration: const InputDecoration(
                    label: Text('نام خانوادگی'),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              SizedBox(
                height: 54,
                child: TextField(
                  controller: phoneNumberController,
                  decoration: const InputDecoration(
                    label: Text('شماره تماس'),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              SizedBox(
                height: 54,
                child: TextField(
                  controller: postalCodeController,
                  decoration: const InputDecoration(
                    label: Text('کد پستی'),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              SizedBox(
                height: 54,
                child: TextField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    label: Text('آدرس'),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              PriceInfo(
                  payablePrice: widget.payablePrice,
                  shippingCost: widget.shippingCost,
                  totalPrice: widget.totalPrice),
              BlocBuilder<ShippingBloc, ShippingState>(
                builder: (context, state) {
                  return state is ShippingLoading
                      ? const Center(
                          child: CupertinoActivityIndicator(),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OutlinedButton(
                                onPressed: () {
                                  BlocProvider.of<ShippingBloc>(context).add(
                                      ShippingCreateOrder(CreateOrderParams(
                                          firstName: firstNameController.text,
                                          lastName: lastNameController.text,
                                          phoneNumber:
                                              phoneNumberController.text,
                                          postalCode: postalCodeController.text,
                                          address: addressController.text,
                                          paymentMethod:
                                              PaymentMethod.cashOnDelivery)));
                                },
                                child: const Text('پرداخت در محل')),
                            const SizedBox(
                              width: 16,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  BlocProvider.of<ShippingBloc>(context).add(
                                      ShippingCreateOrder(CreateOrderParams(
                                          firstName: firstNameController.text,
                                          lastName: lastNameController.text,
                                          phoneNumber:
                                              phoneNumberController.text,
                                          postalCode: postalCodeController.text,
                                          address: addressController.text,
                                          paymentMethod:
                                              PaymentMethod.online)));
                                },
                                child: const Text('پرداخت اینترنتی'))
                          ],
                        );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
