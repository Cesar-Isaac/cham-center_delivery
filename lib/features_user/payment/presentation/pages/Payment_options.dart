import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tracking_provider/core/style/widgets/custom_bottom.dart';
import 'package:tracking_provider/features_user/payment/presentation/pages/payment_page.dart';

class PaymentOptions extends StatelessWidget {
  const PaymentOptions({super.key});
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
              onPressed: () {},
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
                    'orderId': 15,
                    'amount': 2000,
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
