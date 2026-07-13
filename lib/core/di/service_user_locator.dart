import 'package:shared_preferences/shared_preferences.dart';

import '../../features_user/authentication/data/data_sources/auth_local_data.dart';
import '../../features_user/authentication/data/repositories_imp/repository_imp.dart';
import '../../features_user/authentication/domain/usecases/login_usecase.dart';
import '../../features_user/authentication/domain/usecases/logout_usecase.dart';
import '../../features_user/authentication/domain/usecases/signup_usecase.dart';
import '../../features_user/authentication/presentation/manager/auth_cubit.dart';

import '../../features_user/home/data/data_sources/home_local_data_source.dart';

import '../../features_user/home/data/repository_impl/home_repository_impl.dart';
import '../../features_user/home/domain/usecases/get_home_data_usecase.dart';
import '../../features_user/home/presentation/manager/home_cubit.dart';
import '../../features_user/home/presentation/manager/navigation_cubit.dart';

import '../../features_user/role/presentation/manager/role_cubit.dart';
import 'package:http/http.dart' as http;

import '../../features_user/authentication/data/data_sources/location_remote_data_source.dart';
import '../../features_user/authentication/data/repositories_imp/location_repository_impl.dart';
import '../../features_user/authentication/domain/usecases/get_address_from_coordinate_usecase.dart';

import '../../features_user/product/data/data_sources/product_local_data.dart';
import '../../features_user/product/data/repositories_impl/repository_impl.dart';
import '../../features_user/product/domain/usecases/get_product_usecase.dart';
import '../../features_user/product/presentation/manager/product_cubit.dart';

class Locator {
  Locator({
    required SharedPreferences prefs,
  }) : authLocalData = AuthLocalDataSource(prefs);

  // ================= Role =================

  late final RoleCubit roleCubit = RoleCubit();

  // ================= Authentication =================

  final AuthLocalDataSource authLocalData;

  late final AuthRepositoryImpl authRepository =
  AuthRepositoryImpl(authLocalData);

  late final SignupUseCase signupUseCase =
  SignupUseCase(authRepository);

  late final LoginUseCase loginUseCase =
  LoginUseCase(authRepository);

  late final LogoutUseCase logoutUseCase =
  LogoutUseCase(authRepository);
  late final http.Client httpClient =
  http.Client();

  late final LocationRemoteDataSource
  locationRemoteDataSource =
  LocationRemoteDataSourceImpl(
    client: httpClient,
  );

  late final LocationRepositoryImpl
  locationRepository =
  LocationRepositoryImpl(
    locationRemoteDataSource,
  );

  late final GetAddressFromCoordinatesUseCase
  getAddressFromCoordinatesUseCase =
  GetAddressFromCoordinatesUseCase(
    locationRepository,
  );
  late final AuthCubit authCubit = AuthCubit(
    signupUseCase: signupUseCase,
    loginUseCase: loginUseCase,
    logoutUseCase: logoutUseCase,
    getAddressFromCoordinatesUseCase:
    getAddressFromCoordinatesUseCase,
  );

  // ================= Home =================

  late final HomeLocalDataSource homeLocalDataSource =
  HomeLocalDataSourceImpl();

  late final HomeRepositoryImpl homeRepository =
  HomeRepositoryImpl(homeLocalDataSource);

  late final GetHomeDataUseCase getHomeDataUseCase =
  GetHomeDataUseCase(homeRepository);

  late final HomeCubit homeCubit = HomeCubit(
    getHomeDataUseCase: getHomeDataUseCase,
  )
    ..loadHome();

  late final NavigationCubit navigationCubit =
  NavigationCubit();


// ================= Product =================

  late final ProductLocalDataSource
  productLocalDataSource =
  ProductLocalDataSourceImpl();

  late final ProductRepositoryImpl
  productRepository =
  ProductRepositoryImpl(
    productLocalDataSource,
  );

  late final GetProductsUseCase
  getProductsUseCase =
  GetProductsUseCase(
    productRepository,
  );

  late final ProductCubit productCubit =
  ProductCubit(
    getProductsUseCase: getProductsUseCase,
  );
}
late final Locator userGetIt;

Future<void> initUserServiceLocator() async {
  final SharedPreferences prefs =
  await SharedPreferences.getInstance();

  userGetIt = Locator(
    prefs: prefs,
  );
}
