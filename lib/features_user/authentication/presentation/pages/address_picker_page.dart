import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/style/repo/app_colors.dart';
import '../../../../core/style/style/app_theme.dart';
import '../../../../core/style/widgets/primary_button.dart';
import '../manager/auth_cubit.dart';

/// نتيجة اختيار العنوان: الإحداثيات + العنوان النصي.
class PickedAddressResult {
  const PickedAddressResult({
    required this.location,
    required this.address,
  });

  final LatLng location;
  final String address;
}

/// صفحة مشتركة لاختيار عنوان على الخريطة (بالضغط أو عبر GPS)،
/// تُفتح بمسار مسمّى وتعيد [PickedAddressResult] عبر Navigator.pop.
class AddressPickerPage extends StatefulWidget {
  static const String route = '/address-picker';

  const AddressPickerPage({
    super.key,
    required this.initialLocation,
  });

  final LatLng initialLocation;

  @override
  State<AddressPickerPage> createState() =>
      _AddressPickerPageState();
}

class _AddressPickerPageState
    extends State<AddressPickerPage> {
  final MapController _mapController =
  MapController();

  LatLng? _selectedLocation;
  String _selectedAddress = '';
  bool _isResolvingAddress = false;
  bool _isLocatingGps = false;

  @override
  void initState() {
    super.initState();

    _selectedLocation = widget.initialLocation;
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
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

  void _confirmSelection() {
    final LatLng? location = _selectedLocation;

    if (location == null ||
        _isResolvingAddress ||
        _selectedAddress.isEmpty) {
      return;
    }

    Navigator.pop(
      context,
      PickedAddressResult(
        location: location,
        address: _selectedAddress,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تعديل العنوان'),
        actions: [
          IconButton(
            tooltip: 'موقعي الحالي (GPS)',
            onPressed: _isLocatingGps
                ? null
                : _useGpsLocation,
            icon: _isLocatingGps
                ? const SizedBox(
              width: 20,
              height: 20,
              child:
              CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
                : const Icon(
              Icons.my_location_rounded,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter:
              widget.initialLocation,
              initialZoom: 15,
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
                    Text(
                      _selectedAddress.isEmpty
                          ? 'اضغط على الخريطة لاختيار عنوان جديد، أو استخدم زر GPS.'
                          : _selectedAddress,
                      style: AppTheme.bodyM,
                      maxLines: 3,
                      overflow:
                      TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 16),
                    PrimaryButton(
                      text: _isResolvingAddress
                          ? 'جارٍ التحميل...'
                          : 'تأكيد العنوان',
                      icon: Icons.check_rounded,
                      isLoading:
                      _isResolvingAddress,
                      onPressed:
                      _selectedAddress.isEmpty ||
                          _isResolvingAddress
                          ? null
                          : _confirmSelection,
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
