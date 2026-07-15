import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/cart_model.dart';
import '../../domain/entities/cart_entity.dart';

class CartLocalDataSource {
  static const String _cartKey = 'cart_items';

  final SharedPreferences sharedPreferences;

  CartLocalDataSource(this.sharedPreferences);

  List<CartEntity> getCart() {
    final jsonList =
        sharedPreferences.getStringList(_cartKey) ?? [];

    return jsonList.map<CartEntity>((item) {
      final decoded = jsonDecode(item);

      final json = Map<String, dynamic>.from(
        decoded as Map,
      );

      return CartModel.fromJson(json);
    }).toList();
  }

  Future<void> addProduct(CartEntity item) async {
    final cartItems = getCart();

    if (cartItems.isNotEmpty) {
      final hasFood = cartItems.any(
            (element) => element.product.category == 'Food',
      );

      final isFood = item.product.category == 'Food';

      if (hasFood && !isFood) {
        throw Exception(
          'لا يمكن إضافة منتجات غير الطعام إلى سلة تحتوي على طعام.',
        );
      }

      if (!hasFood && isFood) {
        throw Exception(
          'لا يمكن إضافة الطعام إلى سلة تحتوي على منتجات أخرى.',
        );
      }
    }

    final index = cartItems.indexWhere(
          (element) => element.product.id == item.product.id,
    );

    if (index != -1) {
      cartItems[index] = cartItems[index].copyWith(
        quantity: cartItems[index].quantity + 1,
      );
    } else {
      cartItems.add(item);
    }

    await _saveCart(cartItems);
  }

  Future<void> deleteProduct(int productId) async {
    final cartItems = getCart();

    cartItems.removeWhere(
          (element) => element.product.id == productId,
    );

    await _saveCart(cartItems);
  }

  Future<void> increaseQuantity(int productId) async {
    final cartItems = getCart();

    final index = cartItems.indexWhere(
          (element) => element.product.id == productId,
    );

    if (index == -1) return;

    cartItems[index] = cartItems[index].copyWith(
      quantity: cartItems[index].quantity + 1,
    );

    await _saveCart(cartItems);
  }

  Future<void> decreaseQuantity(int productId) async {
    final cartItems = getCart();

    final index = cartItems.indexWhere(
          (element) => element.product.id == productId,
    );

    if (index == -1) return;

    final item = cartItems[index];

    if (item.quantity <= 1) {
      cartItems.removeAt(index);
    } else {
      cartItems[index] = item.copyWith(
        quantity: item.quantity - 1,
      );
    }

    await _saveCart(cartItems);
  }

  Future<void> clearCart() async {
    await sharedPreferences.remove(_cartKey);
  }

  Future<void> _saveCart(List<CartEntity> cartItems) async {
    final jsonList = cartItems.map((item) {
      final model = CartModel.fromEntity(item);
      return jsonEncode(model.toJson());
    }).toList();

    await sharedPreferences.setStringList(
      _cartKey,
      jsonList,
    );
  }
}