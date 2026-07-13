import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/order_model.dart';

abstract class UserOrderLocalDataSource {
  Future<OrderModel> createOrder(OrderModel order);

  Future<List<OrderModel>> getOrders();
}

class UserOrderLocalDataSourceImpl implements UserOrderLocalDataSource {
  static const String _ordersKey = 'user_orders';

  final SharedPreferences sharedPreferences;

  UserOrderLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<OrderModel> createOrder(OrderModel order) async {
    final orders = await getOrders();

    orders.add(order);

    final jsonList = orders
        .map((e) => jsonEncode(e.toJson()))
        .toList();

    await sharedPreferences.setStringList(
      _ordersKey,
      jsonList,
    );

    return order;
  }

  @override
  Future<List<OrderModel>> getOrders() async {
    final jsonList =
    sharedPreferences.getStringList(_ordersKey);

    if (jsonList == null || jsonList.isEmpty) {
      return [];
    }

    return jsonList
        .map(
          (e) => OrderModel.fromJson(
        Map<String, dynamic>.from(jsonDecode(e) as Map),
      ),
    )
        .toList();
  }
}
