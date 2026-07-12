import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../order_tracking/presentation/pages/order_tracking_page.dart';
import '../../domain/entities/enums.dart';
import '../manager/user_order_cubit.dart';
import '../manager/user_order_state.dart';
import '../widgets/user_order_card.dart';

class UserOrdersPage extends StatefulWidget {
  const UserOrdersPage({super.key});

  static const String route = '/user-orders';

  @override
  State<UserOrdersPage> createState() => _UserOrdersPageState();
}

class _UserOrdersPageState extends State<UserOrdersPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserOrderCubit>().loadOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('طلباتي'),
        centerTitle: true,
      ),
      body: BlocConsumer<UserOrderCubit, UserOrderState>(
        listenWhen: (previous, current) {
          return previous.error != current.error;
        },
        listener: (context, state) {
          if (state.error == null) return;

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: Colors.red,
              ),
            );
        },
        builder: (context, state) {
          if (state.status == UserOrderStateStatus.loading &&
              state.orders.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.orders.isEmpty) {
            return const _EmptyOrdersView();
          }

          return RefreshIndicator(
            onRefresh: () {
              return context.read<UserOrderCubit>().loadOrders();
            },
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: state.orders.length,
              separatorBuilder: (_, __) {
                return const SizedBox(height: 16);
              },
              itemBuilder: (context, index) {
                final order = state.orders[index];

                return UserOrderCard(
                  order: order,
                  onTrack:
                  order.status == OrderStatus.delivering
                      ? () async {
                    final delivery = order.delivery;

                    final hasStartLocation =
                    !(delivery.fromLatitude == 0 &&
                        delivery.fromLongitude ==
                            0);

                    final hasEndLocation =
                    !(delivery.toLatitude == 0 &&
                        delivery.toLongitude ==
                            0);

                    if (!hasStartLocation ||
                        !hasEndLocation) {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          const SnackBar(
                            content: Text(
                              'إحداثيات التوصيل غير متوفرة.',
                            ),
                            backgroundColor:
                            Colors.red,
                            behavior:
                            SnackBarBehavior.floating,
                          ),
                        );

                      return;
                    }

                    await Navigator.pushNamed(
                      context,
                      OrderTrackingPage.route,
                      arguments: order,
                    );

                    if (!context.mounted) return;

                    await context
                        .read<UserOrderCubit>()
                        .loadOrders();
                  }
                      : null,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _EmptyOrdersView extends StatelessWidget {
  const _EmptyOrdersView();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return context.read<UserOrderCubit>().loadOrders();
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 160),
          Icon(
            Icons.receipt_long_outlined,
            size: 80,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Center(
            child: Text(
              'لا توجد طلبات حتى الآن',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 8),
          Center(
            child: Text(
              'ستظهر طلباتك هنا بعد إتمام عملية الشراء.',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}