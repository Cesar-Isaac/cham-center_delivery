import 'package:shared_preferences/shared_preferences.dart';

import '../../features-provider/driver/data/gps/driver_gps_repository.dart';
import '../../features-provider/driver/data/simulation/order_simulation_repository.dart';
import '../../features-provider/driver/data/simulation/trip_simulation_repository.dart';
import '../../features-provider/driver/domain/repositories/driver_repository.dart';
import '../../features-provider/driver/domain/repositories/order_repository.dart';
import '../../features-provider/driver/domain/repositories/trip_repository.dart';
import '../../features-provider/history/data/history_local_repository.dart';
import '../../features-provider/history/domain/repositories/history_repository.dart';
import '../../features_user/cart/data/data_sources/cart_local_data.dart';
import '../../features_user/cart/data/repositories_impl/cart_repoditory_impl.dart';
import '../../features_user/cart/domain/usecases/add_product.dart';
import '../../features_user/cart/domain/usecases/clear_cart.dart';
import '../../features_user/cart/domain/usecases/decrease_quantity.dart';
import '../../features_user/cart/domain/usecases/delete_product.dart';
import '../../features_user/cart/domain/usecases/get_cart.dart';
import '../../features_user/cart/domain/usecases/increase_quantity.dart';
import '../../features_user/cart/presentation/manager/cart_cubit.dart';

class Locator {
  Locator({required SharedPreferences prefs})
    : history = HistoryLocalRepository(prefs: prefs);

  final DriverRepository driver = DriverGpsRepository();
  final OrderRepository orders = OrderSimulationRepository();
  final TripRepository trips = TripSimulationRepository();
  final HistoryRepository history;

  ////////////////////cart
  final CartLocalDataSource cartLocalDataSource =
  CartLocalDataSource();


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

}

late final Locator getIt;

Future<void> initServiceLocator() async {
  final prefs = await SharedPreferences.getInstance();
  getIt = Locator(prefs: prefs);


}


