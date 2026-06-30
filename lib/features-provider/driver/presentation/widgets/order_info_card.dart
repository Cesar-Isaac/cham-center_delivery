import 'package:flutter/material.dart';

import '../../domain/entities/order.dart';
import '../../domain/entities/order_category.dart';

/// Compact card shown in the trip screen for each accepted order.
class OrderInfoCard extends StatelessWidget {
  const OrderInfoCard({
    super.key,
    required this.order,
    this.index = 0,
    this.isDelivered = false,
  });

  final Order order;
  final int index;
  final bool isDelivered;

  @override
  Widget build(BuildContext context) {
    final (categoryLabel, categoryIcon, categoryColor) = switch (order.category) {
      OrderCategory.clothing => ('ملابس', Icons.checkroom, Colors.purple),
      OrderCategory.techTools => ('تقنية', Icons.devices, Colors.blue),
      OrderCategory.food => ('طعام', Icons.fastfood, Colors.orange),
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDelivered
            ? const Color(0xFF1A3530)
            : const Color(0xFF1A2535),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDelivered
              ? Colors.green.withValues(alpha: 0.35)
              : Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: categoryColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(categoryIcon, color: categoryColor, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      categoryLabel,
                      style: TextStyle(
                        color: categoryColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'طلب #${index + 1}',
                style: const TextStyle(
                  color: Colors.white38,
                  fontSize: 11,
                ),
              ),
              const Spacer(),
              if (isDelivered)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 12),
                      SizedBox(width: 4),
                      Text(
                        'تم التسليم',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Text(
                  '${_fmt(order.price)} ل.س',
                  style: const TextStyle(
                    color: Colors.tealAccent,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
            ],
          ),

          const SizedBox(height: 10),

          // Customer
          Row(
            children: [
              const Icon(Icons.person_outline, color: Colors.white38, size: 15),
              const SizedBox(width: 6),
              Text(
                order.customerName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                order.phone,
                style: const TextStyle(color: Colors.white38, fontSize: 12),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // Delivery address
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on_outlined, color: Colors.redAccent, size: 15),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  order.deliveryAddress,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Products summary
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: order.products
                .map(
                  (p) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${p.name} ×${p.quantity}',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  String _fmt(double v) =>
      v.toInt().toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]},',
      );
}
