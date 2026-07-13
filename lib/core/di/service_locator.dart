import 'package:shared_preferences/shared_preferences.dart';

// Provider section
import '../../features-provider/driver/data/gps/driver_gps_repository.dart';
import '../../features-provider/driver/data/simulation/order_simulation_repository.dart';
import '../../features-provider/driver/data/simulation/trip_simulation_repository.dart';
import '../../features-provider/driver/domain/repositories/driver_repository.dart';
import '../../features-provider/driver/domain/repositories/order_repository.dart';
import '../../features-provider/driver/domain/repositories/trip_repository.dart';
import '../../features-provider/history/data/history_local_repository.dart';
import '../../features-provider/history/domain/repositories/history_repository.dart';

// User Cart
import '../../features_user/cart/data/data_sources/cart_local_data.dart';
import '../../features_user/cart/data/repositories_impl/cart_repoditory_impl.dart';
import '../../features_user/cart/domain/usecases/add_product.dart';
import '../../features_user/cart/domain/usecases/clear_cart.dart';
import '../../features_user/cart/domain/usecases/decrease_quantity.dart';
import '../../features_user/cart/domain/usecases/delete_product.dart';
import '../../features_user/cart/domain/usecases/get_cart.dart';
import '../../features_user/cart/domain/usecases/increase_quantity.dart';
import '../../features_user/cart/presentation/manager/cart_cubit.dart';

// User Payment
import '../../features_user/payment/data/data_sources/payment_remote_data_source.dart';
import '../../features_user/payment/data/repositories_impl/payment_repository_impl.dart';
import '../../features_user/payment/domain/usecases/payment_usecase.dart';
import '../../features_user/payment/presentation/manager/payment_cubit.dart';

// User Order
import '../../features_user/user_order/data/data_sources/driver_local_data.dart';
import '../../features_user/user_order/data/data_sources/user_order_local_data.dart';
import '../../features_user/user_order/data/repositories_impl/user_order_repository_impl.dart';
import '../../features_user/user_order/domain/usecases/create_user_order_usecase.dart';
import '../../features_user/user_order/domain/usecases/get_user_orders_usecase.dart.dart';
import '../../features_user/user_order/domain/usecases/update_user_order_status_usecase.dart';
import '../../features_user/user_order/presentation/manager/user_order_cubit.dart';

/////////////////
import 'package:http/http.dart' as http;
import '../../features_user/order_tracking/data/data_sources/route_remote_data_source.dart';
import '../../features_user/order_tracking/data/repositories_impl/order_tracking_repository_impl.dart';
import '../../features_user/order_tracking/domain/usecases/get_order_route_usecase.dart';
import '../../features_user/order_tracking/presentation/manager/order_tracking_cubit.dart';




class Locator {
  final HistoryRepository history;
  final CartLocalDataSource cartLocalDataSource;
  final UserOrderLocalDataSource userOrderLocalDataSource;

  Locator({required SharedPreferences prefs})
      : history = HistoryLocalRepository(prefs: prefs),
        cartLocalDataSource = CartLocalDataSource(prefs),
        userOrderLocalDataSource =
        UserOrderLocalDataSourceImpl(prefs);

  ////////////////////////////////////////////////////////////
  // Provider section
  ////////////////////////////////////////////////////////////

  final DriverRepository driver = DriverGpsRepository();

  final OrderRepository orders = OrderSimulationRepository();

  final TripRepository trips = TripSimulationRepository();

  ////////////////////////////////////////////////////////////
  // User Cart



  // cart
  ////////////////////////////////////////////////////////////

  late final CartRepositoryImpl cartRepository =
  CartRepositoryImpl(cartLocalDataSource);

  late final AddProductUseCase addProductUseCase =
  AddProductUseCase(cartRepository);

  late final DeleteProductUseCase deleteProductUseCase =
  DeleteProductUseCase(cartRepository);

  late final GetCartUseCase getCartUseCase =
  GetCartUseCase(cartRepository);

  late final IncreaseQuantityUseCase increaseQuantityUseCase =
  IncreaseQuantityUseCase(cartRepository);

  late final DecreaseQuantityUseCase decreaseQuantityUseCase =
  DecreaseQuantityUseCase(cartRepository);

  late final ClearCartUseCase clearCartUseCase =
  ClearCartUseCase(cartRepository);

  late final CartCubit cartCubit = CartCubit(
    addProductUseCase: addProductUseCase,
    deleteProductUseCase: deleteProductUseCase,
    getCartUseCase: getCartUseCase,
    increaseQuantityUseCase: increaseQuantityUseCase,
    decreaseQuantityUseCase: decreaseQuantityUseCase,
    clearCartUseCase: clearCartUseCase,
  )..loadCart();
////////////////////////////////////////////////////////////
// User Order
////////////////////////////////////////////////////////////

  final UserOrderDriverLocalDataSource
  userOrderDriverLocalDataSource =
  UserOrderDriverLocalDataSource();

  late final UserOrderRepositoryImpl userOrderRepository =
  UserOrderRepositoryImpl(
    userOrderLocalDataSource,
    userOrderDriverLocalDataSource,
  );

  late final CreateUserOrderUseCase createUserOrderUseCase =
  CreateUserOrderUseCase(
    userOrderRepository,
  );

  late final GetUserOrdersUseCase getUserOrdersUseCase =
  GetUserOrdersUseCase(
    userOrderRepository,
  );

  late final UpdateUserOrderStatusUseCase
  updateUserOrderStatusUseCase =
  UpdateUserOrderStatusUseCase(
    userOrderRepository,
  );

  late final UserOrderCubit userOrderCubit = UserOrderCubit(
    createUserOrderUseCase: createUserOrderUseCase,
    getUserOrdersUseCase: getUserOrdersUseCase,
    updateUserOrderStatusUseCase:
    updateUserOrderStatusUseCase,
    clearCartUseCase: clearCartUseCase,
  )..loadOrders();

  ////////////////////////////////////////////////////////////
// Order Tracking
////////////////////////////////////////////////////////////

  final http.Client orderTrackingHttpClient =
  http.Client();

  late final RouteRemoteDataSource
  routeRemoteDataSource =
  RouteRemoteDataSourceImpl(
    orderTrackingHttpClient,
  );

  late final OrderTrackingRepositoryImpl
  orderTrackingRepository =
  OrderTrackingRepositoryImpl(
    routeRemoteDataSource,
  );

  late final GetOrderRouteUseCase
  getOrderRouteUseCase =
  GetOrderRouteUseCase(
    orderTrackingRepository,
  );

  OrderTrackingCubit createOrderTrackingCubit() {
    return OrderTrackingCubit(
      getOrderRouteUseCase: getOrderRouteUseCase,
    );
  }

  ////////////////////////////////////////////////////////////
  // User Payment
  ////////////////////////////////////////////////////////////

  final PaymentRemoteDataSource paymentRemoteDataSource =
  PaymentRemoteDataSourceImpl();

  late final PaymentRepositoryImpl paymentRepository =
  PaymentRepositoryImpl(
    paymentRemoteDataSource,
  );

  late final InitializePaymentUseCase initializePaymentUseCase =
  InitializePaymentUseCase(
    paymentRepository,
  );

  late final PaymentCubit paymentCubit = PaymentCubit(
    initializePaymentUseCase,
  );
}

late final Locator getIt;

Future<void> initServiceLocator() async {
  final prefs = await SharedPreferences.getInstance();

  getIt = Locator(prefs: prefs);
}