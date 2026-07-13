import 'dart:math';

import '../models/driver_model.dart';

class UserOrderDriverLocalDataSource {
  static const List<DriverModel> drivers = [
    DriverModel(
      id: "1",
      name: "محمد أحمد",
      phone: "0991111111",
    ),
    DriverModel(
      id: "2",
      name: "خالد علي",
      phone: "0992222222",
    ),
    DriverModel(
      id: "3",
      name: "أحمد يوسف",
      phone: "0993333333",
    ),
  ];

  DriverModel getRandomDriver() {
    return drivers[Random().nextInt(drivers.length)];
  }
}
