import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';
import 'auth_state.dart';
import '../../domain/usecases/get_address_from_coordinate_usecase.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required this.signupUseCase,
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.getAddressFromCoordinatesUseCase,
  }) : super(const AuthState());

  final SignupUseCase signupUseCase;
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final GetAddressFromCoordinatesUseCase
  getAddressFromCoordinatesUseCase;

  Future<String> resolveAddress({
    required double latitude,
    required double longitude,
  }) async {
    return getAddressFromCoordinatesUseCase(
      latitude: latitude,
      longitude: longitude,
    );
  }

  void updateLocation({
    required String address,
    required double latitude,
    required double longitude,
  }) {
    emit(
      state.copyWith(
        status: AuthStatus.locationUpdated,
        address: address,
        latitude: latitude,
        longitude: longitude,
        errorMessage: '',
      ),
    );
  }

  Future<void> signup(UserEntity user) async {
    emit(
      state.copyWith(
        status: AuthStatus.loading,
        errorMessage: '',
      ),
    );

    try {
      await signupUseCase(user);

      emit(
        state.copyWith(
          status: AuthStatus.signupSuccess,
          user: user,
          errorMessage: '',
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: 'Account creation failed. Please try again.',
        ),
      );
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(
      state.copyWith(
        status: AuthStatus.loading,
        errorMessage: '',
      ),
    );

    try {
      final user = await loginUseCase(
        email: email.trim(),
        password: password,
      );

      if (user == null) {
        emit(
          state.copyWith(
            status: AuthStatus.failure,
            errorMessage: 'Invalid email or password.',
          ),
        );

        return;
      }

      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          errorMessage: '',
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: 'Login failed. Please try again.',
        ),
      );
    }
  }

  Future<void> logout() async {
    try {
      await logoutUseCase();

      emit(
        const AuthState(
          status: AuthStatus.unauthenticated,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: 'Logout failed.',
        ),
      );
    }
  }
}