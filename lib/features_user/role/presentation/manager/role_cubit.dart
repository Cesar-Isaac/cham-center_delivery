import 'package:flutter_bloc/flutter_bloc.dart';

import 'role_state.dart';

class RoleCubit extends Cubit<RoleState> {
  RoleCubit() : super(const RoleState());

  void selectCustomer() {
    emit(
      state.copyWith(
        selectedRole: UserRole.customer,
      ),
    );
  }

  void selectDriver() {
    emit(
      state.copyWith(
        selectedRole: UserRole.driver,
      ),
    );
  }
}