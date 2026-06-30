import 'package:shared_preferences/shared_preferences.dart';

import '../../features-provider/driver/data/gps/driver_gps_repository.dart';
import '../../features-provider/driver/data/simulation/order_simulation_repository.dart';
import '../../features-provider/driver/data/simulation/trip_simulation_repository.dart';
import '../../features-provider/driver/domain/repositories/driver_repository.dart';
import '../../features-provider/driver/domain/repositories/order_repository.dart';
import '../../features-provider/driver/domain/repositories/trip_repository.dart';
import '../../features-provider/history/data/history_local_repository.dart';
import '../../features-provider/history/domain/repositories/history_repository.dart';

class Locator {
  Locator({required SharedPreferences prefs})
    : history = HistoryLocalRepository(prefs: prefs);

  final DriverRepository driver = DriverGpsRepository();
  final OrderRepository orders = OrderSimulationRepository();
  final TripRepository trips = TripSimulationRepository();
  final HistoryRepository history;
}

late final Locator getIt;

Future<void> initServiceLocator() async {
  final prefs = await SharedPreferences.getInstance();
  getIt = Locator(prefs: prefs);
}
