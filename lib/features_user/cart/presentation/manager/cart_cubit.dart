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
    final items = getCartUseCase();
    emit(state.copyWith(items: items));
  }

  void addProduct(ProductEntity product) {
    addProductUseCase(product);
    loadCart();
  }

  void deleteProduct(int productId) {
    deleteProductUseCase(productId);
    loadCart();
  }

  void increaseQuantity(int productId) {
    increaseQuantityUseCase(productId);
    loadCart();
  }

  void decreaseQuantity(int productId) {
    decreaseQuantityUseCase(productId);
    loadCart();
  }

  void clearCart() {
    clearCartUseCase();
    loadCart();
  }
}