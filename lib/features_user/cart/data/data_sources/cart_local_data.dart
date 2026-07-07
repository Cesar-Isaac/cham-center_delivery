import '../../domain/entities/cart_entity.dart';

class CartLocalDataSource {
  final List<CartEntity> _cartItems = [];

  List<CartEntity> getCart() {
    return _cartItems;
  }

  void addProduct(CartEntity item) {
    if (_cartItems.isNotEmpty) {
      final hasFood = _cartItems.any(
            (e) => e.product.category == "food",
      );

      final isFood = item.product.category == "food";

      // السلة فيها طعام والمنتج ليس طعاماً
      if (hasFood && !isFood) {
        throw Exception("لا يمكن إضافة منتجات غير الطعام إلى سلة تحتوي على طعام.");
      }

      // السلة فيها منتجات أخرى والمنتج طعام
      if (!hasFood && isFood) {
        throw Exception("لا يمكن إضافة الطعام إلى سلة تحتوي على منتجات أخرى.");
      }
    }

    final index = _cartItems.indexWhere(
          (e) => e.product.id == item.product.id,
    );

    if (index != -1) {
      _cartItems[index] = _cartItems[index].copyWith(
        quantity: _cartItems[index].quantity + 1,
      );
    } else {
      _cartItems.add(item);
    }
  }

  void deleteProduct(int productId) {
    _cartItems.removeWhere((e) => e.product.id == productId);
  }

  void increaseQuantity(int productId) {
    final index = _cartItems.indexWhere(
          (e) => e.product.id == productId,
    );

    if (index != -1) {
      _cartItems[index] = _cartItems[index].copyWith(
        quantity: _cartItems[index].quantity + 1,
      );
    }
  }

  void decreaseQuantity(int productId) {
    final index = _cartItems.indexWhere(
          (e) => e.product.id == productId,
    );

    if (index == -1) return;

    final item = _cartItems[index];

    if (item.quantity == 1) {
      _cartItems.removeAt(index);
    } else {
      _cartItems[index] = item.copyWith(
        quantity: item.quantity - 1,
      );
    }
  }

  void clearCart() {
    _cartItems.clear();
  }
}