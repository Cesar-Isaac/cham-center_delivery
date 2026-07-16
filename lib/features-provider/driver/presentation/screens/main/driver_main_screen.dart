import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/network/connectivity_cubit.dart';
import '../../../../../core/style/repo/app_colors.dart';
import '../../../../../core/style/widgets/app_tile_layer.dart';
import '../../../domain/entities/trip.dart';
import '../../../domain/types/location.dart';
import '../../state/driver_status/driver_status_cubit.dart';
import '../../state/orders/order_queue_cubit.dart';
import '../../state/trip/trip_cubit.dart';
import '../../widgets/order_bottom_sheet.dart';
import '../../../../history/presentation/state/history_cubit.dart';
import '../../../../profile/presentation/screens/driver_profile_page.dart';
import '../../../../wallet/presentation/screens/wallet_screen.dart';
import '../../../../wallet/presentation/state/wallet_cubit.dart';
import '../trip/trip_screen.dart';

class DriverMainScreen extends StatefulWidget {
  const DriverMainScreen({super.key});

  static const String route = '/';

  @override
  State<DriverMainScreen> createState() => _DriverMainScreenState();
}

class _DriverMainScreenState extends State<DriverMainScreen> {
  /// Current driver position. Always starts at the mall; updated after each trip.
  Location _driverLocation = const Location(
    lat: AppColors.mallLat,
    lng: AppColors.mallLng,
  );
  bool _sheetOpen = false;

  late final TripCubit _tripCubit;
  late final OrderQueueCubit _orderQueueCubit;
  late final DriverStatusCubit _driverStatusCubit;
  late final HistoryCubit _historyCubit;
  late final WalletCubit _walletCubit;
  late final ConnectivityCubit _connectivityCubit;

  @override
  void initState() {
    super.initState();
    // cubits مشتركة مع شاشات الرحلة/السجل/المحفظة عبر getIt،
    // حتى يستطيع AppRouter توفيرها للمسارات المسماة.
    _tripCubit = getIt.tripCubit;
    _historyCubit = getIt.historyCubit;
    _walletCubit = getIt.walletCubit;
    _orderQueueCubit = OrderQueueCubit(ordersRepo: getIt.orders);
    _driverStatusCubit = DriverStatusCubit();
    _connectivityCubit = ConnectivityCubit();
  }

  @override
  void dispose() {
    // لا نغلق cubits الـ getIt المشتركة — تعيش مع التطبيق.
    _orderQueueCubit.close();
    _driverStatusCubit.close();
    _connectivityCubit.close();
    super.dispose();
  }

  void _showOrderSheet(BuildContext ctx) {
    if (_sheetOpen) return;
    _sheetOpen = true;
    showModalBottomSheet<void>(
      context: ctx,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: _orderQueueCubit,
        child: const OrderBottomSheet(),
      ),
    ).then((_) => _sheetOpen = false);
  }

  void _closeSheet(BuildContext ctx) {
    if (!_sheetOpen) return;
    Navigator.of(ctx).pop();
    _sheetOpen = false;
  }

  void _navigateToTrip(BuildContext ctx) {
    Navigator.pushNamed(ctx, TripScreen.route);
  }

  void _navigateToWallet(BuildContext ctx) {
    Navigator.pushNamed(ctx, WalletScreen.route);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _driverStatusCubit),
        BlocProvider.value(value: _orderQueueCubit),
        BlocProvider.value(value: _tripCubit),
        BlocProvider.value(value: _historyCubit),
        BlocProvider.value(value: _connectivityCubit),
      ],
      child: MultiBlocListener(
        listeners: [
          // Connectivity lost → stop new orders; only force offline if no active trip
          BlocListener<ConnectivityCubit, ConnectivityStatus>(
            listener: (ctx, status) {
              if (status != ConnectivityStatus.offline) return;

              // Always stop accepting new orders
              _orderQueueCubit.stop();
              _closeSheet(ctx);

              // If the driver is mid-trip, leave the trip and driver-status alone
              final tripStatus = _tripCubit.state.trip?.status;
              final isOnTrip = tripStatus == TripStatus.started ||
                  tripStatus == TripStatus.arrived;
              if (!isOnTrip && _driverStatusCubit.state == DriverStatus.online) {
                _driverStatusCubit.goOffline();
              }
            },
          ),

          // Online/Offline toggle
          BlocListener<DriverStatusCubit, DriverStatus>(
            listener: (ctx, status) {
              if (status == DriverStatus.online) {
                _orderQueueCubit.start();
              } else {
                _orderQueueCubit.stop();
                _closeSheet(ctx);
              }
            },
          ),

          // Order queue events
          BlocListener<OrderQueueCubit, OrderQueueState>(
            listener: (ctx, state) {
              if (state is OrderQueueShowingOrder) {
                _showOrderSheet(ctx);
              } else if (state is OrderQueueReadyForTrip) {
                _closeSheet(ctx);
                _tripCubit
                    .startTrip(orders: state.orders, startLocation: _driverLocation)
                    .then((_) {
                  if (ctx.mounted) _navigateToTrip(ctx);
                });
              }
            },
          ),

          // Trip completion → update home marker to delivery location
          BlocListener<TripCubit, TripState>(
            listenWhen: (prev, curr) =>
                curr.trip?.status == TripStatus.finished &&
                prev.trip?.status != TripStatus.finished,
            listener: (ctx, tripState) {
              // After return-to-mall leg, driver location is the mall.
              setState(() => _driverLocation = tripState.driverLocation ??
                  const Location(lat: AppColors.mallLat, lng: AppColors.mallLng));

              // Record trip in history and earnings before resetting.
              if (tripState.trip != null) {
                _historyCubit.recordCompletedTrip(tripState.trip!);
                _walletCubit.recordTripEarnings(tripState.trip!);
              }

              _tripCubit.resetTrip();

              if (_driverStatusCubit.state == DriverStatus.online) {
                _orderQueueCubit.resumeAfterTrip(const Duration(minutes: 1));
              }
            },
          ),
        ],
        child: _HomeScaffold(
          driverLocation: _driverLocation,
          onWalletTap: _navigateToWallet,
        ),
      ),
    );
  }
}

// ── Scaffold ───────────────────────────────────────────────────────────────────

class _HomeScaffold extends StatelessWidget {
  const _HomeScaffold({
    required this.driverLocation,
    required this.onWalletTap,
  });
  final Location driverLocation;
  final void Function(BuildContext) onWalletTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1220),
      body: Stack(
        children: [
          // ── Map ──────────────────────────────────────────────────────────
          Positioned.fill(
            child: _HomeMap(location: driverLocation),
          ),

          // ── Top bar ───────────────────────────────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _TopBar(
              onWalletTap: onWalletTap,
            ),
          ),

          // ── Offline banner ────────────────────────────────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 110,
            child: _OfflineBanner(),
          ),

          // ── Status toggle button ──────────────────────────────────────────
          Positioned(
            left: 16,
            right: 16,
            bottom: 30,
            child: const _StatusToggleButton(),
          ),
        ],
      ),
    );
  }
}

// ── Map ────────────────────────────────────────────────────────────────────────

class _HomeMap extends StatelessWidget {
  const _HomeMap({required this.location});
  final Location location;

  @override
  Widget build(BuildContext context) {
    final center = LatLng(location.lat, location.lng);
    return FlutterMap(
      options: MapOptions(initialCenter: center, initialZoom: 15),
      children: [
        const AppTileLayer(maxZoom: 20),
        MarkerLayer(
          markers: [
            // Mall marker
            Marker(
              point: const LatLng(AppColors.mallLat, AppColors.mallLng),
              width: 56,
              height: 64,
              child: const _MallMarker(),
            ),
            // Driver marker
            Marker(
              point: center,
              width: 52,
              height: 52,
              child: _DriverMarker(),
            ),
          ],
        ),
      ],
    );
  }
}

class _MallMarker extends StatelessWidget {
  const _MallMarker();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.deepOrange,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.deepOrange.withValues(alpha: 0.45),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(Icons.store, color: Colors.white, size: 18),
        ),
        Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
            color: Colors.deepOrange,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        Container(
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            color: Colors.deepOrange,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}

class _DriverMarker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.teal,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withValues(alpha: 0.45),
            blurRadius: 14,
            spreadRadius: 3,
          ),
        ],
      ),
      child: const Icon(Icons.directions_car, color: Colors.white, size: 24),
    );
  }
}

// ── Top bar ────────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.onWalletTap,
  });
  final void Function(BuildContext) onWalletTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 16,
        right: 16,
        bottom: 12,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF0B1220).withValues(alpha: 0.95),
            Colors.transparent,
          ],
        ),
      ),
      // بطاقة زجاجية واحدة تضم كل عناصر الشريط،
      // الشعار يتمدد بمرونة فلا يحدث overflow مهما ضاقت الشاشة.
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF0B1220).withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            // Brand mark
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.teal.shade400, Colors.teal.shade800],
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.teal.withValues(alpha: 0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                Icons.local_shipping_outlined,
                color: Colors.white,
                size: 20,
              ),
            ),

            const SizedBox(width: 10),

            // Title + live status
            const Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tracking Provider',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      letterSpacing: 0.2,
                    ),
                  ),
                  SizedBox(height: 3),
                  _OnlineStatusLabel(),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Wallet button
            _IconBtn(
              icon: Icons.account_balance_wallet_outlined,
              onTap: () => onWalletTap(context),
            ),

            const SizedBox(width: 8),

            // Driver profile button
            _IconBtn(
              icon: Icons.person_outline_rounded,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  DriverProfilePage.route,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  const _IconBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.06),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),
          child: Icon(icon, color: Colors.white70, size: 20),
        ),
      ),
    );
  }
}

/// مؤشر الحالة تحت اسم التطبيق: نقطة متوهجة + نص ملوّن.
class _OnlineStatusLabel extends StatelessWidget {
  const _OnlineStatusLabel();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriverStatusCubit, DriverStatus>(
      builder: (_, status) {
        final online = status == DriverStatus.online;
        final color = online ? Colors.greenAccent : Colors.redAccent;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.6),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                online
                    ? 'Online — Receiving orders'
                    : 'Offline',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ── Toggle button ──────────────────────────────────────────────────────────────

class _StatusToggleButton extends StatelessWidget {
  const _StatusToggleButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityCubit, ConnectivityStatus>(
      builder: (ctx, connectivity) {
        final hasInternet = connectivity == ConnectivityStatus.online;
        return BlocBuilder<DriverStatusCubit, DriverStatus>(
          builder: (ctx, status) {
            final online = status == DriverStatus.online;
            return SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: !hasInternet
                      ? Colors.grey.shade800
                      : online
                          ? Colors.green.shade700
                          : Colors.red.shade700,
                  foregroundColor:
                      hasInternet ? Colors.white : Colors.white38,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: hasInternet ? 6 : 0,
                ),
                onPressed: hasInternet
                    ? () {
                        final cubit = ctx.read<DriverStatusCubit>();
                        online ? cubit.goOffline() : cubit.goOnline();
                      }
                    : null,
                icon: Icon(
                  !hasInternet
                      ? Icons.signal_wifi_off
                      : online
                          ? Icons.wifi
                          : Icons.wifi_off,
                  size: 22,
                ),
                label: Text(
                  !hasInternet
                      ? 'لا يوجد اتصال بالإنترنت'
                      : online
                          ? 'أنت متاح — اضغط للتوقف'
                          : 'أنت غير متاح — اضغط للبدء',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// ── Offline banner ─────────────────────────────────────────────────────────────

class _OfflineBanner extends StatelessWidget {
  const _OfflineBanner();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityCubit, ConnectivityStatus>(
      builder: (ctx, status) {
        if (status == ConnectivityStatus.online) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A2E),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.red.withValues(alpha: 0.5)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.signal_wifi_off,
                    color: Colors.redAccent, size: 22),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'الاتصال بالإنترنت مقطوع',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'تحقق من اتصالك ثم أعد المحاولة',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () =>
                      ctx.read<ConnectivityCubit>().retry(),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red.withValues(alpha: 0.15),
                    foregroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'إعادة المحاولة',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
