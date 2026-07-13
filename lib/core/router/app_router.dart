import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_provider/features_user/cart/presentation/pages/cart.dart';
import '../../features_user/authentication/domain/entities/signup_draft_entity.dart';
import '../../features_user/authentication/presentation/manager/auth_cubit.dart';
import '../../features_user/authentication/presentation/pages/location_picker_page.dart';
import '../../features_user/authentication/presentation/pages/login_page.dart';
import '../../features_user/authentication/presentation/pages/signup_page.dart';
import '../../features_user/home/domain/entities/store_entity.dart';
import '../../features_user/home/presentation/manager/home_cubit.dart';
import '../../features_user/home/presentation/manager/navigation_cubit.dart';
import '../../features_user/home/presentation/pages/home_page.dart';
import '../../features_user/product/presentation/pages/product_page.dart';

import '../../features-provider/driver/presentation/screens/main/driver_main_screen.dart';
import '../../features-provider/driver/presentation/screens/trip/trip_screen.dart';
import '../../features-provider/history/presentation/screens/history_screen.dart';
import '../../features-provider/splash/presentation/screens/splash_screen.dart';
import '../../features_user/payment/presentation/pages/Payment_options.dart';
import '../../features_user/payment/presentation/pages/payment_page.dart';
import '../../features_user/user_order/presentation/pages/user_order_page.dart';
import '../../features_user/role/presentation/pages/role_page.dart';
import '../di/service_user_locator.dart';
import '../di/service_locator.dart';

import '../../features_user/product/domain/entities/product_entity.dart';
import '../../features_user/product/presentation/pages/product_details_page.dart';


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

    /// Role
      case RolePage.route:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider.value(
            value: userGetIt.roleCubit,
            child: const RolePage(),
          ),
        );

    /// Signup
      case SignupPage.route:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider.value(
            value: userGetIt.authCubit,
            child: const SignupPage(),
          ),
        );

    /// Location Picker
      case LocationPickerPage.route:
        final arguments = settings.arguments;

        if (arguments is! SignupDraftEntity) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => const Scaffold(
              body: Center(
                child: Text(
                  'Signup information is missing.',
                ),
              ),
            ),
          );
        }

        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider.value(
            value: userGetIt.authCubit,
            child: LocationPickerPage(
              draft: arguments,
            ),
          ),
        );

    /// Login
      case LoginPage.route:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider.value(
            value: userGetIt.authCubit,
            child: const LoginPage(),
          ),
        );

    /// Home
      case HomePage.route:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<AuthCubit>.value(
                  value: userGetIt.authCubit,
                ),
                BlocProvider<HomeCubit>.value(
                  value: userGetIt.homeCubit,
                ),
                BlocProvider<NavigationCubit>.value(
                  value: userGetIt.navigationCubit,
                ),
              ],
              child: const HomePage(),
            );
          },
        );

    /// Products
      case ProductPage.route:
        final Object? arguments = settings.arguments;

        if (arguments is! StoreEntity) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => const Scaffold(
              body: Center(
                child: Text(
                  'Store information is missing.',
                ),
              ),
            ),
          );
        }

        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider.value(
            value: userGetIt.productCubit,
            child: ProductPage(
              store: arguments,
            ),
          ),
        );

    /// Product Details
      case ProductDetailsPage.route:
        final Object? arguments = settings.arguments;

        if (arguments is! ProductEntity) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => const Scaffold(
              body: Center(
                child: Text(
                  'Product information is missing.',
                ),
              ),
            ),
          );
        }

        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider.value(
            value: userGetIt.productCubit,
            child: ProductDetailsPage(
              product: arguments,
            ),
          ),
        );
    // /// Home
    //   case HomePage.route:
    //     return MaterialPageRoute(
    //       builder: (_) => BlocProvider.value(
    //         value: getIt.homeCubit,
    //         child: const HomePage(),
    //       ),
    //     );
    //
    // /// Products
    //   case ProductPage.route:
    //     return MaterialPageRoute(
    //       builder: (_) => BlocProvider.value(
    //         value: getIt.productCubit,
    //         child: const ProductPage(),
    //       ),
    //     );
    //
    // /// Product Details
    //   case ProductDetailsPage.route:
    //     return MaterialPageRoute(
    //       builder: (_) => BlocProvider.value(
    //         value: getIt.productCubit,
    //         child: const ProductDetailsPage(),
    //       ),
    //     );
    //
    // /// Profile
    //   case ProfilePage.route:
    //     return MaterialPageRoute(
    //       builder: (_) => BlocProvider.value(
    //         value: getIt.profileCubit,
    //         child: const ProfilePage(),
    //       ),
    //     );
    //
    // /// Orders
    //   case OrdersPage.route:
    //     return MaterialPageRoute(
    //       builder: (_) => BlocProvider.value(
    //         value: getIt.ordersCubit,
    //         child: const OrdersPage(),
    //       ),
    //     );

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

        default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}
