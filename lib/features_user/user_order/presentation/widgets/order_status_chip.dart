import 'package:flutter/material.dart';

import '../../domain/entities/enums.dart';

class OrderStatusChip extends StatelessWidget {
  final OrderStatus status;

  const OrderStatusChip({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.40),
        ),
      ),
      child: Text(
        _statusLabel(status),
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _statusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;

      case OrderStatus.preparing:
        return Colors.blue;

      case OrderStatus.delivering:
        return Colors.purple;

      case OrderStatus.completed:
        return Colors.green;

      case OrderStatus.cancelled:
        return Colors.red;
    }
  }

  String _statusLabel(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'قيد الانتظار';

      case OrderStatus.preparing:
        return 'قيد التحضير';

      case OrderStatus.delivering:
        return 'قيد التوصيل';

      case OrderStatus.completed:
        return 'مكتمل';

      case OrderStatus.cancelled:
        return 'ملغي';
    }
  }
}