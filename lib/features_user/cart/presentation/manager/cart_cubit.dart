import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../product/domain/entities/product_entity.dart';
import '../../domain/usecases/add_product.dart';
import '../../domain/usecases/clear_cart.dart';
import '../../domain/usecases/decrease_quantity.dart';
import '../../domain/usecases/delete_product.dart';
import '../../domain/usecases/get_cart.dart';
import '../../domain/usecases/increase_quantity.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final AddProductUseCase addProductUseCase;
  final DeleteProductUseCase deleteProductUseCase;
  final GetCartUseCase getCartUseCase;
  final IncreaseQuantityUseCase increaseQuantityUseCase;
  final DecreaseQuantityUseCase decreaseQuantityUseCase;
  final ClearCartUseCase clearCartUseCase;

  CartCubit({
    required this.addProductUseCase,
    required this.deleteProductUseCase,
    required this.getCartUseCase,
    required this.increaseQuantityUseCase,
    required this.decreaseQuantityUseCase,
    required this.clearCartUseCase,
  }) : super(const CartState());

  void loadCart() {
    try {
      final items = getCartUseCase();

      emit(
        state.copyWith(
          items: items,
          loading: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          loading: false,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> addProduct(ProductEntity product) async {
    emit(state.copyWith(loading: true));

    try {
      await addProductUseCase(product);
      loadCart();
    } catch (e) {
      emit(
        state.copyWith(
          loading: false,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> deleteProduct(int productId) async {
    try {
      await deleteProductUseCase(productId);
      loadCart();
    } catch (e) {
      emit(
        state.copyWith(
          loading: false,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> increaseQuantity(int productId) async {
    try {
      await increaseQuantityUseCase(productId);
      loadCart();
    } catch (e) {
      emit(
        state.copyWith(
          loading: false,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> decreaseQuantity(int productId) async {
    try {
      await decreaseQuantityUseCase(productId);
      loadCart();
    } catch (e) {
      emit(
        state.copyWith(
          loading: false,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> clearCart() async {
    try {
      await clearCartUseCase();
      loadCart();
    } catch (e) {
      emit(
        state.copyWith(
          loading: false,
          error: e.toString(),
        ),
      );
    }
  }
}