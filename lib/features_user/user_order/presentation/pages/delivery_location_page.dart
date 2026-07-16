import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/style/repo/app_colors.dart';
import '../../../../core/style/style/app_theme.dart';
import '../../../../core/style/widgets/primary_button.dart';
import '../../../authentication/presentation/manager/auth_cubit.dart';
import '../../../cart/domain/entities/cart_entity.dart';
import '../../../payment/presentation/pages/Payment_options.dart';

class DeliveryLocationPage extends StatefulWidget {
  static const String route = '/delivery-location';

  const DeliveryLocationPage({
    super.key,
    required this.cartItems,
    required this.totalPrice,
  });

  final List<CartEntity> cartItems;
  final double totalPrice;

  @override
  State<DeliveryLocationPage> createState() =>
      _DeliveryLocationPageState();
}

class _DeliveryLocationPageState
    extends State<DeliveryLocationPage> {
  final MapController _mapController =
  MapController();

  LatLng? _selectedLocation;
  String _selectedAddress = '';
  bool _isResolvingAddress = false;
  bool _isLocatingGps = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _useAccountAddress(moveMap: false);
    });
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  /// موقع الحساب المحفوظ في معلومات المستخدم.
  void _useAccountAddress({bool moveMap = true}) {
    final user =
        context.read<AuthCubit>().state.user;

    if (user == null) return;

    final point = LatLng(
      user.latitude,
      user.longitude,
    );

    setState(() {
      _selectedLocation = point;
      _selectedAddress = user.address;
      _isResolvingAddress = false;
    });

    if (moveMap) {
      _mapController.move(point, 15);
    }
  }

  /// تحديد الموقع الحالي تلقائياً باستخدام GPS.
  Future<void> _useGpsLocation() async {
    if (_isLocatingGps) return;

    setState(() {
      _isLocatingGps = true;
    });

    try {
      final bool serviceEnabled =
      await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        throw Exception(
          'خدمة الموقع غير مفعلة، يرجى تفعيل GPS.',
        );
      }

      LocationPermission permission =
      await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission =
        await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission ==
              LocationPermission.deniedForever) {
        throw Exception(
          'لم يتم منح إذن الوصول إلى الموقع.',
        );
      }

      final Position position =
      await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      if (!mounted) return;

      final point = LatLng(
        position.latitude,
        position.longitude,
      );

      _mapController.move(point, 16);

      await _selectLocation(point);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              e
                  .toString()
                  .replaceFirst('Exception: ', ''),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
    } finally {
      if (mounted) {
        setState(() {
          _isLocatingGps = false;
        });
      }
    }
  }

  Future<void> _selectLocation(LatLng point) async {
    setState(() {
      _selectedLocation = point;
      _selectedAddress = 'جارٍ تحميل العنوان...';
      _isResolvingAddress = true;
    });

    try {
      final String address = await context
          .read<AuthCubit>()
          .resolveAddress(
        latitude: point.latitude,
        longitude: point.longitude,
      );

      if (!mounted) return;

      setState(() {
        _selectedAddress = address;
        _isResolvingAddress = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _selectedAddress =
        'الموقع المحدد على الخريطة';
        _isResolvingAddress = false;
      });
    }
  }

  void _continueToPayment() {
    final LatLng? location = _selectedLocation;

    if (location == null || _isResolvingAddress) {
      return;
    }

    Navigator.pushNamed(
      context,
      PaymentOptions.route,
      arguments: {
        'cartItems': widget.cartItems,
        'totalPrice': widget.totalPrice,
        'deliveryAddress': _selectedAddress,
        'deliveryLatitude': location.latitude,
        'deliveryLongitude': location.longitude,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user =
        context.read<AuthCubit>().state.user;

    final LatLng initialCenter = LatLng(
      user?.latitude ?? 33.5138,
      user?.longitude ?? 36.2765,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('مكان التوصيل'),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: initialCenter,
              initialZoom: 14,
              minZoom: 3,
              maxZoom: 19,
              onTap: (_, point) {
                _selectLocation(point);
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName:
                'com.example.tracking_provider',
              ),
              if (_selectedLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _selectedLocation!,
                      width: 64,
                      height: 64,
                      alignment:
                      Alignment.topCenter,
                      child: const Icon(
                        Icons.location_on_rounded,
                        color: AppColors.primary,
                        size: 54,
                      ),
                    ),
                  ],
                ),
              const RichAttributionWidget(
                attributions: [
                  TextSourceAttribution(
                    'OpenStreetMap contributors',
                  ),
                ],
              ),
            ],
          ),

          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  Expanded(
                    child: _LocationOptionButton(
                      icon: Icons.home_rounded,
                      label: 'عنوان حسابي',
                      onPressed: user == null
                          ? null
                          : _useAccountAddress,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _LocationOptionButton(
                      icon:
                      Icons.my_location_rounded,
                      label: 'موقعي الحالي (GPS)',
                      isLoading: _isLocatingGps,
                      onPressed: _isLocatingGps
                          ? null
                          : _useGpsLocation,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.bgSheet,
                  borderRadius:
                  BorderRadius.circular(22),
                  border: Border.all(
                    color: AppColors.divider,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons
                              .location_on_outlined,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _selectedLocation ==
                                null
                                ? 'لم يتم اختيار مكان التوصيل'
                                : 'عنوان التوصيل',
                            style: AppTheme.titleM,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _selectedLocation == null
                          ? 'اختر عنوان حسابك، أو حدد موقعك عبر GPS، أو اضغط على الخريطة.'
                          : _selectedAddress,
                      style: AppTheme.bodyM,
                      maxLines: 3,
                      overflow:
                      TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 18),
                    PrimaryButton(
                      text: _isResolvingAddress
                          ? 'جارٍ التحميل...'
                          : 'متابعة إلى الدفع',
                      icon: Icons
                          .payments_outlined,
                      isLoading:
                      _isResolvingAddress,
                      onPressed:
                      _selectedLocation == null ||
                          _isResolvingAddress
                          ? null
                          : _continueToPayment,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationOptionButton extends StatelessWidget {
  const _LocationOptionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.bgSheet,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            borderRadius:
            BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.divider,
            ),
          ),
          child: Row(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [
              if (isLoading)
                const SizedBox(
                  width: 18,
                  height: 18,
                  child:
                  CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              else
                Icon(
                  icon,
                  color: AppColors.primary,
                  size: 20,
                ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style: AppTheme.labelM.copyWith(
                    color:
                    AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
