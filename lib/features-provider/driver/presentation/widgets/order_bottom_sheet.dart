import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/order.dart';
import '../../domain/entities/order_category.dart';
import '../state/orders/order_queue_cubit.dart';

/// Modal bottom sheet that shows an incoming order and auto-dismisses via the
/// cubit's 2-minute timer. The [onClose] callback is invoked whenever the
/// sheet should be popped by external state (e.g. ReadyForTrip).
class OrderBottomSheet extends StatefulWidget {
  const OrderBottomSheet({super.key});

  @override
  State<OrderBottomSheet> createState() => _OrderBottomSheetState();
}

class _OrderBottomSheetState extends State<OrderBottomSheet> {
  static const _totalSeconds = 120;
  int _remaining = _totalSeconds;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    _remaining = _totalSeconds;
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        if (_remaining > 0) {
          _remaining--;
        } else {
          _countdownTimer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderQueueCubit, OrderQueueState>(
      listenWhen: (prev, curr) =>
          curr is OrderQueueShowingOrder && prev is OrderQueueShowingOrder
              ? curr.order.id != prev.order.id
              : false,
      listener: (_, _) {
        // A new order replaced the previous one → reset countdown.
        _startCountdown();
      },
      builder: (context, state) {
        if (state is! OrderQueueShowingOrder) {
          return const SizedBox.shrink();
        }

        final order = state.order;
        final pending = state.pendingOrders;
        final progress = _remaining / _totalSeconds;

        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0F1923),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.6),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 6),
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      _CategoryBadge(category: order.category),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          pending.isEmpty
                              ? 'طلب جديد!'
                              : 'طلب إضافي متوافق',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      _CountdownRing(progress: progress, seconds: _remaining),
                    ],
                  ),
                ),

                // Previously accepted orders (multi-order trip context)
                if (pending.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  _PendingOrdersBanner(orders: pending),
                ],

                const Divider(color: Colors.white12, height: 20),

                // Order details
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _OrderDetails(order: order),
                ),

                const SizedBox(height: 16),

                // Action buttons
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.redAccent,
                            side: const BorderSide(color: Colors.redAccent),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () =>
                              context.read<OrderQueueCubit>().rejectActive(),
                          icon: const Icon(Icons.close),
                          label: Text(
                            pending.isNotEmpty ? 'رفض (ابدأ بالموجود)' : 'رفض',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal.shade600,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () =>
                              context.read<OrderQueueCubit>().acceptActive(),
                          icon: const Icon(Icons.check),
                          label: const Text(
                            'قبول',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ── Sub-widgets ────────────────────────────────────────────────────────────────

class _CountdownRing extends StatelessWidget {
  const _CountdownRing({required this.progress, required this.seconds});
  final double progress;
  final int seconds;

  @override
  Widget build(BuildContext context) {
    final color = progress > 0.5
        ? Colors.teal
        : progress > 0.25
        ? Colors.orange
        : Colors.redAccent;

    return SizedBox(
      width: 50,
      height: 50,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: progress,
            strokeWidth: 4,
            backgroundColor: Colors.white12,
            valueColor: AlwaysStoppedAnimation(color),
          ),
          Text(
            '$seconds',
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  const _CategoryBadge({required this.category});
  final OrderCategory category;

  @override
  Widget build(BuildContext context) {
    final (label, icon, color) = switch (category) {
      OrderCategory.clothing => ('ملابس', Icons.checkroom, Colors.purple),
      OrderCategory.techTools => ('تقنية', Icons.devices, Colors.blue),
      OrderCategory.food => ('طعام', Icons.fastfood, Colors.orange),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _PendingOrdersBanner extends StatelessWidget {
  const _PendingOrdersBanner({required this.orders});
  final List<Order> orders;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.teal.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.teal.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.shopping_bag_outlined, color: Colors.teal, size: 14),
              SizedBox(width: 6),
              Text(
                'الطلبات المقبولة مسبقاً في الرحلة:',
                style: TextStyle(
                  color: Colors.teal,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ...orders.map(
            (o) => Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                '• ${o.customerName} — ${o.deliveryAddress}',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderDetails extends StatelessWidget {
  const _OrderDetails({required this.order});
  final Order order;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Customer
        _InfoRow(
          icon: Icons.person_outline,
          label: order.customerName,
          sub: order.phone,
        ),
        const SizedBox(height: 10),
        // Pickup
        _InfoRow(
          icon: Icons.store_outlined,
          label: 'الاستلام',
          sub: order.pickupAddress,
          iconColor: Colors.orange,
        ),
        const SizedBox(height: 10),
        // Delivery
        _InfoRow(
          icon: Icons.location_on_outlined,
          label: 'التسليم',
          sub: order.deliveryAddress,
          iconColor: Colors.redAccent,
        ),
        const SizedBox(height: 14),
        // Products
        const Text(
          'المنتجات:',
          style: TextStyle(
            color: Colors.white54,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        ...order.products.map(
          (p) => Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Row(
              children: [
                const Icon(Icons.circle, color: Colors.white24, size: 6),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${p.name}  ×${p.quantity}',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ),
                Text(
                  '${_fmt(p.price * p.quantity)} ل.س',
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
        const Divider(color: Colors.white12, height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'إجمالي الطلب',
              style: TextStyle(color: Colors.white54, fontSize: 13),
            ),
            Text(
              '${_fmt(order.price)} ل.س',
              style: const TextStyle(
                color: Colors.tealAccent,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _fmt(double v) =>
      v.toInt().toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]},',
      );
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.sub,
    this.iconColor = Colors.white54,
  });
  final IconData icon;
  final String label;
  final String sub;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: iconColor, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              Text(
                sub,
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
