import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:nike_ecommerce/common/exceptions.dart';
import 'package:nike_ecommerce/data/auth_info.dart';
import 'package:nike_ecommerce/data/cart_response.dart';
import 'package:nike_ecommerce/data/repo/cart_repository.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final ICartRepository repository;

  CartBloc(this.repository) : super(CartLoading()) {
    on<CartEvent>((event, emit) async {
      if (event is CartStarted) {
        final authInfo = event.authInfo;
        if (authInfo == null || authInfo.accessToken.isEmpty) {
          emit(CartAuthRequired());
        } else {
          await loadCartItems(emit, event.isRefreshing);
        }
      } else if (event is CartDeleteButtonClicked) {
        try {
          if (state is CartSuccess) {
            final successState = (state as CartSuccess);
            final cartItem = successState.cartResponse.cartItems
                .firstWhere((element) => element.id == event.cartItemId);
            cartItem.deleteButtonLaoding = true;
            emit(CartSuccess(successState.cartResponse));
          }
          await repository.delete(event.cartItemId);
          await repository.count();
          if (state is CartSuccess) {
            final successState = (state as CartSuccess);
            successState.cartResponse.cartItems
                .removeWhere((element) => element.id == event.cartItemId);
            if (successState.cartResponse.cartItems.isEmpty) {
              emit(CartEmpty());
            } else {
              emit(calculatePriceInfo(successState.cartResponse));
            }
          }
        } catch (e) {
          debugPrint(e.toString());
        }
      } else if (event is CartAuthInfoChanged) {
        if (event.authInfo == null || event.authInfo!.accessToken.isEmpty) {
          emit(CartAuthRequired());
        } else {
          if (state is CartAuthRequired) {
            await loadCartItems(emit, false);
          }
        }
      } else if (event is CartPlusButtonClicked ||
          event is CartMinusButtonClicked) {
        try {
          int cartItemId = 0;
          if (event is CartPlusButtonClicked) {
            cartItemId = event.cartItemId;
          } else if (event is CartMinusButtonClicked) {
            cartItemId = event.cartItemId;
          }

          if (state is CartSuccess) {
            final successState = (state as CartSuccess);
            final cartItem = successState.cartResponse.cartItems
                .firstWhere((element) => element.id == cartItemId);
            cartItem.changeCountLoading = true;
            emit(CartSuccess(successState.cartResponse));

            int newwCount = event is CartPlusButtonClicked
                ? cartItem.count + 1
                : cartItem.count - 1;
            await repository.changeCount(cartItemId, newwCount);
            await repository.count();

            cartItem
              ..count = newwCount
              ..changeCountLoading = false;
            emit(calculatePriceInfo(successState.cartResponse));
          }
        } catch (e) {
          debugPrint(e.toString());
        }
      }
    });
  }

  Future<void> loadCartItems(Emitter<CartState> emit, bool isRefreshing) async {
    try {
      if (!isRefreshing) {
        emit(CartLoading());
      }
      final result = await repository.getAll();
      if (result.cartItems.isEmpty) {
        emit(CartEmpty());
      } else {
        emit(CartSuccess(result));
      }
    } catch (e) {
      emit(CartError(AppException()));
    }
  }

  CartSuccess calculatePriceInfo(CartResponse cartResponse) {
    int payablePrice = 0;
    int totalPrice = 0;
    int shippingCost = 0;

    cartResponse.cartItems.forEach((cartItem) {
      payablePrice += cartItem.product.price * cartItem.count;
      totalPrice += cartItem.product.previousPrice * cartItem.count;
    });

    shippingCost = payablePrice >= 250000 ? 0 : 30000;

    cartResponse.payablePrice = payablePrice;
    cartResponse.totalPrice = totalPrice;
    cartResponse.shippingCost = shippingCost;

    return CartSuccess(cartResponse);
  }
}
