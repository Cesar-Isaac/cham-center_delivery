import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/style/repo/app_colors.dart';
import '../../../driver/domain/entities/trip.dart';
import '../../domain/entities/wallet_entry.dart';
import '../../domain/repositories/wallet_repository.dart';

class WalletCubit extends Cubit<List<WalletEntry>> {
  final WalletRepository _repo;

  WalletCubit({required WalletRepository repo})
      : _repo = repo,
        super(repo.getAll());

  static const Distance _distance = Distance();

  /// نسبة العمولة حسب مسافة التوصيل من المول:
  /// أقل من 3 كم → %5، من 3 إلى 7 كم → %8، أكثر من 7 كم → %12.
  static double commissionRateFor(double distanceKm) {
    if (distanceKm < 3) return 0.05;
    if (distanceKm <= 7) return 0.08;
    return 0.12;
  }

  /// تسجيل أرباح رحلة مكتملة: عمولة لكل طلب أوصله السائق.
  void recordTripEarnings(Trip trip) {
    const mall = LatLng(AppColors.mallLat, AppColors.mallLng);

    for (final order in trip.orders) {
      final double distanceKm = _distance.as(
        LengthUnit.Kilometer,
        mall,
        LatLng(order.deliveryLat, order.deliveryLng),
      );

      final double rate = commissionRateFor(distanceKm);

      _repo.addEntry(
        WalletEntry(
          orderId: order.id,
          customerName: order.customerName,
          orderPrice: order.price,
          distanceKm: distanceKm,
          rate: rate,
          amount: order.price * rate,
          earnedAt: DateTime.now(),
        ),
      );
    }

    emit(_repo.getAll());
  }

  void reload() => emit(_repo.getAll());
}
