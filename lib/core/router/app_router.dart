import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_provider/features_user/cart/presentation/pages/cart.dart';

import '../../features-provider/driver/presentation/screens/main/driver_main_screen.dart';
import '../../features-provider/driver/presentation/screens/trip/trip_screen.dart';
import '../../features-provider/history/presentation/screens/history_screen.dart';
import '../../features-provider/splash/presentation/screens/splash_screen.dart';
import '../../features_user/order_tracking/presentation/manager/order_tracking_cubit.dart';
import '../../features_user/order_tracking/presentation/pages/order_tracking_page.dart';
import '../../features_user/payment/presentation/pages/Payment_options.dart';
import '../../features_user/payment/presentation/pages/payment_page.dart';
import '../../features_user/user_order/domain/entities/order_entity.dart';
import '../../features_user/user_order/presentation/manager/user_order_cubit.dart';
import '../../features_user/user_order/presentation/pages/user_order_page.dart';
import '../di/service_locator.dart';


class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SplashScreen.route:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case DriverMainScreen.route:
        return MaterialPageRoute(builder: (_) => const DriverMainScreen());
      case TripScreen.route:
        return MaterialPageRoute(builder: (_) => const TripScreen());
      case HistoryScreen.route:
        return MaterialPageRoute(builder: (_) => const HistoryScreen());
        ///////////////// user Pages
    /////// cart page
      case Cart.route:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: getIt.cartCubit,
            child: const Cart(),
          ),
        );
        //payment options page
      case PaymentOptions.route:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: getIt.paymentCubit,
            child: const PaymentOptions(),
          ),
        );
        // Payment page
      case PaymentPage.route:

        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(

          builder: (_) => BlocProvider.value(

            value: getIt.paymentCubit,

            child: PaymentPage(

              orderId: args['orderId'],

              amount: args['amount'],

            ),

          ),

        );
        //////////////////// user orders
      case UserOrdersPage.route:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: getIt.userOrderCubit,
            child: const UserOrdersPage(),
          ),
        );

        ////////////
      case OrderTrackingPage.route:
        final arguments = settings.arguments;

        if (arguments is! OrderEntity) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(
                child: Text(
                  'بيانات الطلب غير صحيحة.',
                ),
              ),
            ),
          );
        }

        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider<OrderTrackingCubit>(
                create: (_) =>
                    getIt.createOrderTrackingCubit(),
              ),
              BlocProvider<UserOrderCubit>.value(
                value: getIt.userOrderCubit,
              ),
            ],
            child: OrderTrackingPage(
              order: arguments,
            ),
          ),
        );
        /////////////////
        default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}
