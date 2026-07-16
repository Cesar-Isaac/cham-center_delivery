import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/check_account_availability_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';
import '../../domain/usecases/update_user_usecase.dart';
import 'auth_state.dart';
import '../../domain/usecases/get_address_from_coordinate_usecase.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required this.signupUseCase,
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.updateUserUseCase,
    required this.checkAccountAvailabilityUseCase,
    required this.getAddressFromCoordinatesUseCase,
  }) : super(const AuthState());

  final SignupUseCase signupUseCase;
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final UpdateUserUseCase updateUserUseCase;
  final CheckAccountAvailabilityUseCase
  checkAccountAvailabilityUseCase;
  final GetAddressFromCoordinatesUseCase
  getAddressFromCoordinatesUseCase;

  /// يعيد رسالة خطأ إذا كان البريد أو الهاتف مستخدمين
  /// من حساب سابق، أو null إذا كانا متاحين.
  String? checkAccountAvailability({
    required String email,
    required String phone,
  }) {
    return checkAccountAvailabilityUseCase(
      email: email,
      phone: phone,
    );
  }

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
    } catch (e) {
      final String message = e
          .toString()
          .replaceFirst('Exception: ', '');

      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: message.isEmpty
              ? 'Account creation failed. Please try again.'
              : message,
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

  Future<void> updateProfile(
      UserEntity updatedUser,
      ) async {
    emit(
      state.copyWith(
        status: AuthStatus.loading,
        errorMessage: '',
      ),
    );

    try {
      await updateUserUseCase(updatedUser);

      emit(
        state.copyWith(
          status: AuthStatus.profileUpdated,
          user: updatedUser,
          errorMessage: '',
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage:
          'Profile update failed. Please try again.',
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