import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/style/repo/app_colors.dart';
import '../../../../core/style/style/app_theme.dart';
import '../../../../core/style/widgets/primary_button.dart';
import '../../domain/entities/signup_draft_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../manager/auth_cubit.dart';
import '../manager/auth_state.dart';
import 'login_page.dart';

class LocationPickerPage extends StatefulWidget {
  static const String route = '/location-picker';

  const LocationPickerPage({
    super.key,
    required this.draft,
  });

  final SignupDraftEntity draft;

  @override
  State<LocationPickerPage> createState() =>
      _LocationPickerPageState();
}

class _LocationPickerPageState
    extends State<LocationPickerPage> {
  static const LatLng _initialLocation = LatLng(
    33.5138,
    36.2765,
  );

  LatLng? _selectedLocation;
  String _selectedAddress = '';
  bool _isResolvingAddress = false;

  Future<void> _selectLocation(
      LatLng point,
      ) async {
    setState(() {
      _selectedLocation = point;
      _selectedAddress =
      'Loading address...';
      _isResolvingAddress = true;
    });

    try {
      final String address =
      await context
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

      context.read<AuthCubit>().updateLocation(
        address: address,
        latitude: point.latitude,
        longitude: point.longitude,
      );
    } catch (_) {
      if (!mounted) return;

      const String fallbackAddress =
          'Selected location on the map';

      setState(() {
        _selectedAddress = fallbackAddress;
        _isResolvingAddress = false;
      });

      context.read<AuthCubit>().updateLocation(
        address: fallbackAddress,
        latitude: point.latitude,
        longitude: point.longitude,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not load the address name. '
                'The selected location was saved.',
          ),
        ),
      );
    }
  }

  Future<void> _completeSignup() async {
    final LatLng? location =
        _selectedLocation;

    if (location == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Please select your address.',
          ),
        ),
      );

      return;
    }

    if (_isResolvingAddress) {
      return;
    }

    final UserEntity user = UserEntity(
      id: DateTime.now()
          .millisecondsSinceEpoch,
      fullName: widget.draft.fullName,
      email: widget.draft.email,
      phone: widget.draft.phone,
      password: widget.draft.password,
      address: _selectedAddress,
      latitude: location.latitude,
      longitude: location.longitude,
    );

    await context
        .read<AuthCubit>()
        .signup(user);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (previous, current) {
        return previous.status !=
            current.status;
      },
      listener: (context, state) {
        if (state.status ==
            AuthStatus.signupSuccess) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            LoginPage.route,
                (route) => false,
          );
        }

        if (state.status ==
            AuthStatus.failure) {
          ScaffoldMessenger.of(context)
              .showSnackBar(
            SnackBar(
              content:
              Text(state.errorMessage),
            ),
          );
        }
      },
      builder: (context, state) {
        final bool isSignupLoading =
            state.status ==
                AuthStatus.loading;

        final bool isLoading =
            isSignupLoading ||
                _isResolvingAddress;

        return Scaffold(
          appBar: AppBar(
            title:
            const Text('Select Address'),
          ),
          body: Stack(
            children: [
              FlutterMap(
                options: MapOptions(
                  initialCenter:
                  _initialLocation,
                  initialZoom: 13,
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
                  if (_selectedLocation !=
                      null)
                    MarkerLayer(
                      markers: [
                        Marker(
                          point:
                          _selectedLocation!,
                          width: 64,
                          height: 64,
                          alignment:
                          Alignment.topCenter,
                          child: const Icon(
                            Icons
                                .location_on_rounded,
                            color:
                            AppColors.primary,
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
                  child: Container(
                    padding:
                    const EdgeInsets.all(
                      16,
                    ),
                    decoration: BoxDecoration(
                      color:
                      AppColors.bgSheet,
                      borderRadius:
                      BorderRadius.circular(
                        18,
                      ),
                      border: Border.all(
                        color:
                        AppColors.divider,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons
                              .touch_app_rounded,
                          color:
                          AppColors.primary,
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: Text(
                            'Tap anywhere on the map to select your address.',
                            style:
                            AppTheme.bodyM,
                          ),
                        ),
                      ],
                    ),
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
                    padding:
                    const EdgeInsets.all(
                      18,
                    ),
                    decoration: BoxDecoration(
                      color:
                      AppColors.bgSheet,
                      borderRadius:
                      BorderRadius.circular(
                        22,
                      ),
                      border: Border.all(
                        color:
                        AppColors.divider,
                      ),
                    ),
                    child: Column(
                      mainAxisSize:
                      MainAxisSize.min,
                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons
                                  .location_on_outlined,
                              color: AppColors
                                  .primary,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text(
                                _selectedLocation ==
                                    null
                                    ? 'No address selected'
                                    : 'Selected Address',
                                style: AppTheme
                                    .titleM,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        AnimatedSwitcher(
                          duration:
                          const Duration(
                            milliseconds: 250,
                          ),
                          child:
                          _isResolvingAddress
                              ? Row(
                            key: const ValueKey(
                              'loading-address',
                            ),
                            children: [
                              const SizedBox(
                                width:
                                18,
                                height:
                                18,
                                child:
                                CircularProgressIndicator(
                                  strokeWidth:
                                  2,
                                ),
                              ),
                              const SizedBox(
                                width:
                                10,
                              ),
                              Expanded(
                                child:
                                Text(
                                  'Loading address...',
                                  style:
                                  AppTheme.bodyM,
                                ),
                              ),
                            ],
                          )
                              : Text(
                            key: const ValueKey(
                              'address',
                            ),
                            _selectedLocation ==
                                null
                                ? 'Choose a location to continue.'
                                : _selectedAddress,
                            style:
                            AppTheme.bodyM,
                            maxLines: 3,
                            overflow:
                            TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        PrimaryButton(
                          text:
                          _isResolvingAddress
                              ? 'Loading...'
                              : 'Done',
                          icon: Icons
                              .check_rounded,
                          isLoading:
                          isLoading,
                          onPressed:
                          _selectedLocation ==
                              null ||
                              isLoading
                              ? null
                              : _completeSignup,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}