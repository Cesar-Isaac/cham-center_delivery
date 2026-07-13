import 'package:flutter/material.dart';

import '../../domain/entities/enums.dart';
import '../../domain/entities/order_entity.dart';
import 'order_information_row.dart';
import 'order_status_chip.dart';

class UserOrderCard extends StatelessWidget {
  final OrderEntity order;

  const UserOrderCard({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        childrenPadding: const EdgeInsets.fromLTRB(
          16,
          0,
          16,
          16,
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                'طلب رقم ${order.id}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            OrderStatusChip(
              status: order.status,
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            '${order.totalItems} منتجات • '
                '${order.totalPrice.toStringAsFixed(2)}',
          ),
        ),
        children: [
          const Divider(),

          const _SectionTitle(
            icon: Icons.shopping_bag_outlined,
            title: 'المنتجات',
          ),

          const SizedBox(height: 8),

          ...order.products.map(
                (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      item.product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '${item.quantity} × '
                        '${item.product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Divider(),

          OrderInformationRow(
            icon: Icons.payments_outlined,
            label: 'طريقة الدفع',
            value: _paymentMethodLabel(
              order.paymentMethod,
            ),
          ),

          OrderInformationRow(
            icon: Icons.attach_money,
            label: 'السعر النهائي',
            value: order.totalPrice.toStringAsFixed(2),
          ),

          OrderInformationRow(
            icon: Icons.person_outline,
            label: 'المستخدم',
            value: order.user.name,
          ),

          const Divider(),

          const _SectionTitle(
            icon: Icons.delivery_dining_outlined,
            title: 'السائق',
          ),

          const SizedBox(height: 8),

          OrderInformationRow(
            icon: Icons.badge_outlined,
            label: 'الاسم',
            value: order.driver.name,
          ),

          OrderInformationRow(
            icon: Icons.phone_outlined,
            label: 'الهاتف',
            value: order.driver.phone,
          ),

          const Divider(),

          const _SectionTitle(
            icon: Icons.location_on_outlined,
            title: 'مسار التوصيل',
          ),

          const SizedBox(height: 8),

          OrderInformationRow(
            icon: Icons.store_outlined,
            label: 'من',
            value: order.delivery.from,
          ),

          OrderInformationRow(
            icon: Icons.home_outlined,
            label: 'إلى',
            value: order.delivery.to,
          ),

          OrderInformationRow(
            icon: Icons.access_time,
            label: 'التاريخ',
            value: _formatDate(order.createdAt),
          ),
        ],
      ),
    );
  }

  String _paymentMethodLabel(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cash:
        return 'دفع نقدي';

      case PaymentMethod.electronic:
        return 'دفع إلكتروني';
    }
  }

  String _formatDate(DateTime date) {
    String digits(int value) {
      return value.toString().padLeft(2, '0');
    }

    return '${date.year}/'
        '${digits(date.month)}/'
        '${digits(date.day)} - '
        '${digits(date.hour)}:'
        '${digits(date.minute)}';
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionTitle({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}