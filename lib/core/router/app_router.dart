import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_provider/features_user/cart/presentation/pages/cart.dart';

import '../../features-provider/driver/presentation/screens/main/driver_main_screen.dart';
import '../../features-provider/driver/presentation/screens/trip/trip_screen.dart';
import '../../features-provider/history/presentation/screens/history_screen.dart';
import '../../features-provider/splash/presentation/screens/splash_screen.dart';
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
      case Cart.route:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: getIt.cartCubit,
            child: const Cart(),
          ),
        );
        default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}
