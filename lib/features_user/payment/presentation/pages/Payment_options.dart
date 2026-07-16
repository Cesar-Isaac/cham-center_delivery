import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_provider/core/style/widgets/custom_bottom.dart';
import 'package:tracking_provider/features_user/payment/presentation/pages/payment_page.dart';

import '../../../authentication/presentation/manager/auth_cubit.dart';
import '../../../cart/domain/entities/cart_entity.dart';
import '../../../cart/presentation/manager/cart_cubit.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../user_order/domain/entities/enums.dart';
import '../../../user_order/presentation/manager/user_order_cubit.dart';

class PaymentOptions extends StatelessWidget {


  final List<CartEntity> cartItems;
  final double totalPrice;
  final String? deliveryAddress;
  final double? deliveryLatitude;
  final double? deliveryLongitude;

  const PaymentOptions({
    super.key,
    required this.cartItems,
    required this.totalPrice,
    this.deliveryAddress,
    this.deliveryLatitude,
    this.deliveryLongitude,
  });

  static const route = '/paymentOptions';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            CustomButton(
              text: 'كاش',
              onPressed: () async {
                final user = context.read<AuthCubit>().state.user;

                if (user == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'يجب تسجيل الدخول قبل إنشاء الطلب.',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );

                  return;
                }

                final order = await context
                    .read<UserOrderCubit>()
                    .createOrder(
                  cartItems: cartItems,
                  user: user,
                  paymentMethod: PaymentMethod.cash,
                  deliveryAddress: deliveryAddress,
                  deliveryLatitude: deliveryLatitude,
                  deliveryLongitude: deliveryLongitude,
                );

                if (!context.mounted) return;

                if (order == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'تعذر إنشاء الطلب، حاول مرة أخرى.',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );

                  return;
                }

                 context.read<CartCubit>().loadCart();



                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم إنشاء الطلب بنجاح.'),
                    backgroundColor: Colors.green,
                  ),
                );

                Navigator.pushNamedAndRemoveUntil(
                  context,
                  HomePage.route,
                      (route) => false,
                );
              },
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),

            CustomButton(
              text: 'بطاقة البنك',
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  PaymentPage.route,
                  arguments: {
                    'orderId': DateTime.now().millisecondsSinceEpoch,
                    'amount': (totalPrice * 100).round(),
                    'cartItems': cartItems,
                    'deliveryAddress': deliveryAddress,
                    'deliveryLatitude': deliveryLatitude,
                    'deliveryLongitude': deliveryLongitude,
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
