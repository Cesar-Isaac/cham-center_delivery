import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moyasar/moyasar.dart';

import '../../../authentication/presentation/manager/auth_cubit.dart';
import '../../../cart/domain/entities/cart_entity.dart';
import '../../../cart/presentation/manager/cart_cubit.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../user_order/domain/entities/enums.dart';
import '../../../user_order/presentation/manager/user_order_cubit.dart';
import '../manager/payment_cubit.dart';
import '../manager/payment_state.dart';

class PaymentPage extends StatefulWidget {
  final int orderId;
  final int amount;
  final List<CartEntity> cartItems;

  const PaymentPage({
    super.key,
    required this.orderId,
    required this.amount,
    required this.cartItems,
  });

  static const String route = '/payment';

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool _paymentHandled = false;
  bool _isCreatingOrder = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final paymentCubit = context.read<PaymentCubit>();

      paymentCubit.reset();

      paymentCubit.initializePayment(
        orderId: widget.orderId,
        amount: widget.amount,
        description: 'Order ${widget.orderId}',
      );
    });
  }

  Future<void> _handlePaymentResult(
      dynamic result,
      ) async {
    if (_paymentHandled) return;

    if (result is! PaymentResponse) {
      _showMessage(
        message: 'تعذر قراءة نتيجة عملية الدفع.',
        color: Colors.red,
      );

      return;
    }

    if (result.status != PaymentStatus.paid) {
      _showMessage(
        message: 'حدث خطأ أثناء الدفع.',
        color: Colors.red,
      );

      return;
    }

    /*
     * نضع القيمة true مباشرة بعد نجاح الدفع، حتى لو أعادت
     * بوابة الدفع النتيجة مرة أخرى لا يتم إنشاء طلب جديد.
     */
    _paymentHandled = true;

    final user = context.read<AuthCubit>().state.user;

    if (user == null) {
      _showMessage(
        message: 'يجب تسجيل الدخول قبل إنشاء الطلب.',
        color: Colors.red,
      );

      return;
    }

    setState(() {
      _isCreatingOrder = true;
    });

    final order = await context
        .read<UserOrderCubit>()
        .createOrder(
      cartItems: widget.cartItems,
      user: user,
      paymentMethod: PaymentMethod.electronic,
    );

    if (!mounted) return;

    setState(() {
      _isCreatingOrder = false;
    });

    if (order == null) {
      _showMessage(
        message: 'تم الدفع، ولكن تعذر إنشاء الطلب.',
        color: Colors.red,
      );

      return;
    }

     context.read<CartCubit>().loadCart();



    _showMessage(
      message: 'تم الدفع وإنشاء الطلب بنجاح.',
      color: Colors.green,
    );

    Navigator.pushNamedAndRemoveUntil(
      context,
      HomePage.route,
          (route) => false,
    );
  }

  void _showMessage({
    required String message,
    required Color color,
  }) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الدفع'),
        ),
        body: BlocBuilder<PaymentCubit, PaymentState>(
          builder: (context, state) {
            if (state is PaymentLoading ||
                state is PaymentInitial) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is PaymentError) {
              return _PaymentErrorView(
                message: state.message,
                onRetry: () {
                  context
                      .read<PaymentCubit>()
                      .initializePayment(
                    orderId: widget.orderId,
                    amount: widget.amount,
                    description:
                    'Order ${widget.orderId}',
                  );
                },
              );
            }

            if (state is PaymentReady) {
              final config = PaymentConfig(
                publishableApiKey:
                'pk_test_H4KvysgniSLP5URjTAmv7BNXKTcjmRMt3Yk5UyD6',
                amount: state.payment.amount,
                description: state.payment.description,
                currency: 'USD',
              );

              return Stack(
                children: [
                  AbsorbPointer(
                    absorbing: _isCreatingOrder,
                    child: CreditCard(
                      config: config,
                      onPaymentResult: _handlePaymentResult,
                    ),
                  ),
                  if (_isCreatingOrder)
                    Container(
                      color: Colors.black26,
                      alignment: Alignment.center,
                      child: const Card(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 16),
                              Text(
                                'جارٍ إنشاء الطلب...',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              );
            }

            return const Center(
              child: Text('جارٍ تحضير عملية الدفع...'),
            );
          },
        ),
      ),
    );
  }
}

class _PaymentErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _PaymentErrorView({
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
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}