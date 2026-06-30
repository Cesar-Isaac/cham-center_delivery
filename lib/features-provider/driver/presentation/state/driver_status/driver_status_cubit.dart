import 'package:flutter_bloc/flutter_bloc.dart';

enum DriverStatus { online, offline }

class DriverStatusCubit extends Cubit<DriverStatus> {
  DriverStatusCubit() : super(DriverStatus.offline);

  void goOnline() => emit(DriverStatus.online);

  void goOffline() => emit(DriverStatus.offline);
}
