import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/enums.dart';
import '../models/order_model.dart';

abstract class UserOrderLocalDataSource {
  Future<OrderModel> createOrder(
      OrderModel order,
      );

  Future<List<OrderModel>> getOrders();

  Future<OrderModel> updateOrderStatus({
    required String orderId,
    required OrderStatus status,
  });
}

class UserOrderLocalDataSourceImpl
    implements UserOrderLocalDataSource {
  static const String _ordersKey = 'user_orders';

  final SharedPreferences sharedPreferences;

  UserOrderLocalDataSourceImpl(
      this.sharedPreferences,
      );

  @override
  Future<OrderModel> createOrder(
      OrderModel order,
      ) async {
    final orders = await getOrders();

    final orderAlreadyExists = orders.any(
          (savedOrder) => savedOrder.id == order.id,
    );

    if (orderAlreadyExists) {
      throw Exception(
        'رقم الطلب مستخدم مسبقاً.',
      );
    }

    orders.add(order);

    await _saveOrders(orders);

    return order;
  }

  @override
  Future<List<OrderModel>> getOrders() async {
    final jsonList = sharedPreferences.getStringList(
      _ordersKey,
    );

    if (jsonList == null || jsonList.isEmpty) {
      return [];
    }

    return jsonList.map((jsonString) {
      final decodedJson = jsonDecode(jsonString);

      if (decodedJson is! Map) {
        throw const FormatException(
          'بيانات أحد الطلبات غير صحيحة.',
        );
      }

      return OrderModel.fromJson(
        Map<String, dynamic>.from(decodedJson),
      );
    }).toList();
  }

  @override
  Future<OrderModel> updateOrderStatus({
    required String orderId,
    required OrderStatus status,
  }) async {
    final orders = await getOrders();

    final orderIndex = orders.indexWhere(
          (order) => order.id == orderId,
    );

    if (orderIndex == -1) {
      throw Exception(
        'الطلب رقم $orderId غير موجود.',
      );
    }

    final updatedEntity = orders[orderIndex].copyWith(
      status: status,
    );

    final updatedOrder = OrderModel.fromEntity(
      updatedEntity,
    );

    orders[orderIndex] = updatedOrder;

    await _saveOrders(orders);

    return updatedOrder;
  }

  Future<void> _saveOrders(
      List<OrderModel> orders,
      ) async {
    final jsonList = orders.map((order) {
      return jsonEncode(
        order.toJson(),
      );
    }).toList();

    final saved = await sharedPreferences.setStringList(
      _ordersKey,
      jsonList,
    );

    if (!saved) {
      throw Exception(
        'تعذر حفظ الطلبات محلياً.',
      );
    }
  }
}