import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_ecommerce/common/exceptions.dart';
import 'package:nike_ecommerce/data/add_to_cart_response.dart';
import 'package:nike_ecommerce/data/repo/cart_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ICartRepository repository;

  ProductBloc(this.repository) : super(ProductInitial()) {
    on<ProductEvent>((event, emit) async {
      if (event is CartAddButtonClick) {
        try {
          emit(ProductAddToCartLoading());
          final result = await repository.add(event.productId);
          await repository.count();
          emit(ProductAddToCartSuccess(result));
        } catch (e) {
          emit(ProductAddToCartError(AppException()));
        }
      }
    });
  }
}
