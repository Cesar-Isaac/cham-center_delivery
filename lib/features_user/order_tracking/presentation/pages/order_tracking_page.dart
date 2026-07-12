import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../user_order/domain/entities/order_entity.dart';
import '../../../user_order/presentation/manager/user_order_cubit.dart';
import '../../domain/entities/route_point_entity.dart';
import '../manager/order_tracking_cubit.dart';
import '../manager/order_tracking_state.dart';
import '../widgets/tracking_map.dart';

class OrderTrackingPage extends StatefulWidget {
  final OrderEntity order;

  const OrderTrackingPage({
    super.key,
    required this.order,
  });

  static const String route = '/order-tracking';

  @override
  State<OrderTrackingPage> createState() {
    return _OrderTrackingPageState();
  }
}

class _OrderTrackingPageState
    extends State<OrderTrackingPage> {
  bool _isCompletingOrder = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _startTracking();
    });
  }

  void _startTracking() {
    final delivery = widget.order.delivery;

    context.read<OrderTrackingCubit>().startTracking(
      startLatitude: delivery.fromLatitude,
      startLongitude: delivery.fromLongitude,
      endLatitude: delivery.toLatitude,
      endLongitude: delivery.toLongitude,
    );
  }

  Future<void> _completeOrder() async {
    // منع تنفيذ تحديث الحالة أكثر من مرة
    if (_isCompletingOrder) return;

    _isCompletingOrder = true;

    final updatedOrder = await context
        .read<UserOrderCubit>()
        .markOrderCompleted(
      widget.order.id,
    );

    if (!mounted) return;

    if (updatedOrder == null) {
      _isCompletingOrder = false;

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              'وصل السائق، لكن تعذر تحديث حالة الطلب.',
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );

      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text(
            'تم توصيل الطلب بنجاح.',
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 1),
        ),
      );

    await Future<void>.delayed(
      const Duration(seconds: 1),
    );

    if (!mounted) return;

    Navigator.pop(
      context,
      updatedOrder,
    );
  }

  @override
  Widget build(BuildContext context) {
    final delivery = widget.order.delivery;

    final startLocation = RoutePointEntity(
      latitude: delivery.fromLatitude,
      longitude: delivery.fromLongitude,
    );

    final endLocation = RoutePointEntity(
      latitude: delivery.toLatitude,
      longitude: delivery.toLongitude,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'تتبع الطلب ${widget.order.id}',
        ),
      ),
      body: BlocConsumer<
          OrderTrackingCubit,
          OrderTrackingState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) async {
          if (state.status ==
              OrderTrackingStatus.completed) {
            await _completeOrder();
          }

          if (state.status ==
              OrderTrackingStatus.error &&
              state.error != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.error!),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
          }
        },
        builder: (context, state) {
          if (state.status ==
              OrderTrackingStatus.loading ||
              state.status ==
                  OrderTrackingStatus.initial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.status ==
              OrderTrackingStatus.error) {
            return _TrackingErrorView(
              message: state.error ??
                  'تعذر تحميل مسار التوصيل.',
              onRetry: _startTracking,
            );
          }

          final driverLocation =
              state.driverLocation;

          if (driverLocation == null ||
              state.routePoints.isEmpty) {
            return const Center(
              child: Text(
                'لا توجد بيانات للمسار.',
              ),
            );
          }

          return Stack(
            children: [
              TrackingMap(
                routePoints: state.routePoints,
                driverLocation: driverLocation,
                startLocation: startLocation,
                endLocation: endLocation,
              ),

              Positioned(
                left: 16,
                right: 16,
                bottom: 24,
                child: _TrackingInformationCard(
                  progress: state.progress,
                  isCompleted: state.status ==
                      OrderTrackingStatus.completed,
                  isUpdatingOrder:
                  _isCompletingOrder,
                  driverName:
                  widget.order.driver.name,
                  driverPhone:
                  widget.order.driver.phone,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TrackingInformationCard
    extends StatelessWidget {
  final double progress;
  final bool isCompleted;
  final bool isUpdatingOrder;
  final String driverName;
  final String driverPhone;

  const _TrackingInformationCard({
    required this.progress,
    required this.isCompleted,
    required this.isUpdatingOrder,
    required this.driverName,
    required this.driverPhone,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  isCompleted
                      ? Icons.check_circle
                      : Icons.delivery_dining,
                  color: isCompleted
                      ? Colors.green
                      : Colors.blue,
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: Text(
                    _getStatusMessage(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                if (isUpdatingOrder)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                else
                  Text(
                    '${(progress * 100).round()}%',
                  ),
              ],
            ),

            const SizedBox(height: 12),

            LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              borderRadius: BorderRadius.circular(10),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                const Icon(
                  Icons.person_outline,
                  size: 20,
                ),

                const SizedBox(width: 6),

                Expanded(
                  child: Text(
                    driverName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                const SizedBox(width: 8),

                const Icon(
                  Icons.phone_outlined,
                  size: 20,
                ),

                const SizedBox(width: 6),

                Text(driverPhone),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusMessage() {
    if (isUpdatingOrder) {
      return 'جارٍ تأكيد وصول الطلب...';
    }

    if (isCompleted) {
      return 'تم توصيل الطلب';
    }

    return 'السائق في الطريق إليك';
  }
}

class _TrackingErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _TrackingErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),

            const SizedBox(height: 16),

            Text(
              message,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text(
                'إعادة المحاولة',
              ),
            ),
          ],
        ),
      ),
    );
  }
}