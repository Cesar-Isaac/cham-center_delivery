import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:tracking_provider/features_user/cart/presentation/pages/cart.dart';
import '../../features_user/authentication/domain/entities/signup_draft_entity.dart';
import '../../features_user/authentication/presentation/manager/auth_cubit.dart';
import '../../features_user/authentication/presentation/pages/location_picker_page.dart';
import '../../features_user/authentication/presentation/pages/login_page.dart';
import '../../features_user/authentication/presentation/pages/signup_page.dart';
import '../../features_user/cart/domain/entities/cart_entity.dart';
import '../../features_user/cart/presentation/manager/cart_cubit.dart';
import '../../features_user/home/domain/entities/store_entity.dart';
import '../../features_user/home/presentation/manager/home_cubit.dart';
import '../../features_user/home/presentation/manager/navigation_cubit.dart';
import '../../features_user/home/presentation/pages/home_page.dart';
import '../../features_user/product/presentation/pages/product_page.dart';

import '../../features-provider/auth/presentation/screens/driver_location_picker_page.dart';
import '../../features-provider/auth/presentation/screens/driver_login_page.dart';
import '../../features-provider/auth/presentation/screens/driver_signup_page.dart';
import '../../features-provider/driver/presentation/screens/main/driver_main_screen.dart';
import '../../features-provider/driver/presentation/screens/trip/trip_screen.dart';
import '../../features-provider/history/presentation/screens/history_screen.dart';
import '../../features-provider/profile/presentation/screens/driver_edit_profile_page.dart';
import '../../features-provider/profile/presentation/screens/driver_profile_page.dart';
import '../../features-provider/splash/presentation/screens/splash_screen.dart';
import '../../features-provider/wallet/presentation/screens/wallet_screen.dart';
import '../../features_user/authentication/presentation/pages/address_picker_page.dart';
import '../../features_user/order_tracking/presentation/manager/order_tracking_cubit.dart';
import '../../features_user/order_tracking/presentation/pages/order_tracking_page.dart';
import '../../features_user/payment/presentation/pages/Payment_options.dart';
import '../../features_user/payment/presentation/pages/payment_page.dart';
import '../../features_user/user_order/domain/entities/order_entity.dart';
import '../../features_user/user_order/presentation/manager/user_order_cubit.dart';
import '../../features_user/user_order/presentation/pages/delivery_location_page.dart';
import '../../features_user/user_order/presentation/pages/user_order_page.dart';
import '../../features_user/profile/presentation/pages/edit_profile_page.dart';
import '../../features_user/role/presentation/pages/role_page.dart';
import '../../features_user/splash/presentation/pages/user_splash_screen.dart';
import '../di/service_user_locator.dart';
import '../di/service_locator.dart';

import '../../features_user/product/domain/entities/product_entity.dart';
import '../../features_user/product/presentation/pages/product_details_page.dart';
import '../../features_user/favorites/presentation/manager/favorites_cubit.dart';


class AppRouter {

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SplashScreen.route:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case DriverMainScreen.route:
        return MaterialPageRoute(builder: (_) => const DriverMainScreen());
      case TripScreen.route:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider.value(
            value: getIt.tripCubit,
            child: const TripScreen(),
          ),
        );
      case HistoryScreen.route:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider.value(
            value: getIt.historyCubit,
            child: const HistoryScreen(),
          ),
        );
      case WalletScreen.route:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider.value(
            value: getIt.walletCubit,
            child: const WalletScreen(),
          ),
        );

        // صفحة اختيار العنوان المشتركة (تعيد النتيجة عبر pop)
      case AddressPickerPage.route:
        final Object? initialLocation = settings.arguments;

        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider.value(
            value: userGetIt.authCubit,
            child: AddressPickerPage(
              initialLocation: initialLocation is LatLng
                  ? initialLocation
                  : const LatLng(33.5138, 36.2765),
            ),
          ),
        );

        ///////////////// driver auth Pages
        // سلسلة auth مستقلة للسائق تستخدم driverAuthCubit
        // بتخزين منفصل عن حساب المستخدم.

      case DriverSignupPage.route:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider<AuthCubit>.value(
            value: userGetIt.driverAuthCubit,
            child: const DriverSignupPage(),
          ),
        );

      case DriverLocationPickerPage.route:
        final Object? driverDraft = settings.arguments;

        if (driverDraft is! SignupDraftEntity) {
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
          builder: (_) => BlocProvider<AuthCubit>.value(
            value: userGetIt.driverAuthCubit,
            child: DriverLocationPickerPage(
              draft: driverDraft,
            ),
          ),
        );

      case DriverLoginPage.route:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider<AuthCubit>.value(
            value: userGetIt.driverAuthCubit,
            child: const DriverLoginPage(),
          ),
        );

      case DriverProfilePage.route:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider<AuthCubit>.value(
            value: userGetIt.driverAuthCubit,
            child: const DriverProfilePage(),
          ),
        );

      case DriverEditProfilePage.route:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider<AuthCubit>.value(
            value: userGetIt.driverAuthCubit,
            child: const DriverEditProfilePage(),
          ),
        );

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

    /// User Splash
      case UserSplashScreen.route:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const UserSplashScreen(),
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
                BlocProvider<UserOrderCubit>.value(
                  value: getIt.userOrderCubit,
                ),
                BlocProvider<FavoritesCubit>.value(
                  value: userGetIt.favoritesCubit,
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
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: userGetIt.productCubit,
              ),
              BlocProvider<FavoritesCubit>.value(
                value: userGetIt.favoritesCubit,
              ),
            ],
            child: ProductPage(
              store: arguments,
            ),
          ),
        );

    /// Product Details
      case ProductDetailsPage.route:
        final Object? arguments = settings.arguments;

        ProductEntity? product;
        String? productHeroTag;

        if (arguments is ProductEntity) {
          product = arguments;
        } else if (arguments is Map<String, dynamic>) {
          final productArgument = arguments['product'];
          final heroTagArgument = arguments['heroTag'];

          if (productArgument is ProductEntity) {
            product = productArgument;
          }

          if (heroTagArgument is String) {
            productHeroTag = heroTagArgument;
          }
        }

        if (product == null) {
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

        final ProductEntity selectedProduct = product;

        return MaterialPageRoute(
          settings: settings,
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: userGetIt.productCubit,
              ),
              BlocProvider<CartCubit>.value(
                value: getIt.cartCubit,
              ),
              BlocProvider<FavoritesCubit>.value(
                value: userGetIt.favoritesCubit,
              ),
            ],
            child: ProductDetailsPage(
              product: selectedProduct,
              heroTag: productHeroTag,
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

        // edit profile page
      case EditProfilePage.route:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider<AuthCubit>.value(
            value: userGetIt.authCubit,
            child: const EditProfilePage(),
          ),
        );

        // delivery location page
      case DeliveryLocationPage.route:
        final arguments = settings.arguments;

        if (arguments is! Map<String, dynamic>) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => const Scaffold(
              body: Center(
                child: Text('بيانات السلة غير متوفرة.'),
              ),
            ),
          );
        }

        final cartItemsArgument = arguments['cartItems'];
        final totalPriceArgument = arguments['totalPrice'];

        if (cartItemsArgument is! List ||
            totalPriceArgument is! num) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => const Scaffold(
              body: Center(
                child: Text('بيانات السلة غير صحيحة.'),
              ),
            ),
          );
        }

        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider<AuthCubit>.value(
            value: userGetIt.authCubit,
            child: DeliveryLocationPage(
              cartItems: List<CartEntity>.from(
                cartItemsArgument,
              ),
              totalPrice:
              totalPriceArgument.toDouble(),
            ),
          ),
        );

        //payment options page
      case PaymentOptions.route:
        final arguments = settings.arguments;

        if (arguments is! Map<String, dynamic>) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => const Scaffold(
              body: Center(
                child: Text('بيانات السلة غير متوفرة.'),
              ),
            ),
          );
        }

        final cartItemsArgument = arguments['cartItems'];
        final totalPriceArgument = arguments['totalPrice'];

        if (cartItemsArgument is! List ||
            totalPriceArgument is! num) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => const Scaffold(
              body: Center(
                child: Text('بيانات السلة غير صحيحة.'),
              ),
            ),
          );
        }

        final cartItems = List<CartEntity>.from(
          cartItemsArgument,
        );

        final totalPrice = totalPriceArgument.toDouble();

        final deliveryAddressArgument =
        arguments['deliveryAddress'];
        final deliveryLatitudeArgument =
        arguments['deliveryLatitude'];
        final deliveryLongitudeArgument =
        arguments['deliveryLongitude'];

        return MaterialPageRoute(
          settings: settings,
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: getIt.paymentCubit,
              ),
              BlocProvider<AuthCubit>.value(
                value: userGetIt.authCubit,
              ),
              BlocProvider<UserOrderCubit>.value(
                value: getIt.userOrderCubit,
              ),
              BlocProvider<CartCubit>.value(
                value: getIt.cartCubit,
              ),
            ],
            child: PaymentOptions(
              cartItems: cartItems,
              totalPrice: totalPrice,
              deliveryAddress:
              deliveryAddressArgument is String
                  ? deliveryAddressArgument
                  : null,
              deliveryLatitude:
              deliveryLatitudeArgument is num
                  ? deliveryLatitudeArgument.toDouble()
                  : null,
              deliveryLongitude:
              deliveryLongitudeArgument is num
                  ? deliveryLongitudeArgument.toDouble()
                  : null,
            ),
          ),
        );

        // Payment page
      case PaymentPage.route:
        final arguments = settings.arguments;

        if (arguments is! Map<String, dynamic>) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => const Scaffold(
              body: Center(
                child: Text('بيانات الدفع غير متوفرة.'),
              ),
            ),
          );
        }

        final orderIdArgument = arguments['orderId'];
        final amountArgument = arguments['amount'];
        final cartItemsArgument = arguments['cartItems'];

        if (orderIdArgument is! num ||
            amountArgument is! num ||
            cartItemsArgument is! List) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => const Scaffold(
              body: Center(
                child: Text('بيانات الدفع غير صحيحة.'),
              ),
            ),
          );
        }

        final cartItems = List<CartEntity>.from(
          cartItemsArgument,
        );

        final deliveryAddressArgument =
        arguments['deliveryAddress'];
        final deliveryLatitudeArgument =
        arguments['deliveryLatitude'];
        final deliveryLongitudeArgument =
        arguments['deliveryLongitude'];

        return MaterialPageRoute(
          settings: settings,
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: getIt.paymentCubit,
              ),
              BlocProvider<AuthCubit>.value(
                value: userGetIt.authCubit,
              ),
              BlocProvider<UserOrderCubit>.value(
                value: getIt.userOrderCubit,
              ),
              BlocProvider<CartCubit>.value(
                value: getIt.cartCubit,
              ),
            ],
            child: PaymentPage(
              orderId: orderIdArgument.toInt(),
              amount: amountArgument.toInt(),
              cartItems: cartItems,
              deliveryAddress:
              deliveryAddressArgument is String
                  ? deliveryAddressArgument
                  : null,
              deliveryLatitude:
              deliveryLatitudeArgument is num
                  ? deliveryLatitudeArgument.toDouble()
                  : null,
              deliveryLongitude:
              deliveryLongitudeArgument is num
                  ? deliveryLongitudeArgument.toDouble()
                  : null,
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
