import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/order.dart';
import '../../../domain/repositories/order_repository.dart';

// ── States ────────────────────────────────────────────────────────────────────

sealed class OrderQueueState {
  const OrderQueueState();
}

final class OrderQueueIdle extends OrderQueueState {
  const OrderQueueIdle();
}

/// An order is being shown to the driver.
/// [pendingOrders] holds orders the driver already accepted for the current trip.
final class OrderQueueShowingOrder extends OrderQueueState {
  final Order order;
  final List<Order> pendingOrders;

  const OrderQueueShowingOrder({
    required this.order,
    this.pendingOrders = const [],
  });
}

/// All orders accumulated — ready to start the trip.
final class OrderQueueReadyForTrip extends OrderQueueState {
  final List<Order> orders;

  const OrderQueueReadyForTrip(this.orders);
}

// ── Cubit ─────────────────────────────────────────────────────────────────────

class OrderQueueCubit extends Cubit<OrderQueueState> {
  final OrderRepository _ordersRepo;

  static const _maxOrdersPerTrip = 2;

  Timer? _scheduleTimer;
  Timer? _autoRejectTimer;
  final _rng = Random();

  bool _enabled = false;
  Order? _activeOrder;
  final List<Order> _pendingOrders = [];

  OrderQueueCubit({required OrderRepository ordersRepo})
    : _ordersRepo = ordersRepo,
      super(const OrderQueueIdle());

  // ── Public API ─────────────────────────────────────────────────────────────

  /// Enable and start scheduling orders (15–30 s intervals).
  void start() {
    if (_enabled) return;
    _enabled = true;
    _pendingOrders.clear();
    _scheduleNext();
  }

  /// Completely disable simulation (driver went offline).
  void stop() {
    _enabled = false;
    _scheduleTimer?.cancel();
    _autoRejectTimer?.cancel();
    _scheduleTimer = null;
    _autoRejectTimer = null;
    _activeOrder = null;
    _pendingOrders.clear();
    emit(const OrderQueueIdle());
  }

  /// Resume after trip ends — waits [delay] then resumes scheduling.
  void resumeAfterTrip(Duration delay) {
    _scheduleTimer?.cancel();
    _scheduleTimer = Timer(delay, () {
      if (isClosed) return;
      _enabled = true;
      _pendingOrders.clear();
      _scheduleNext();
    });
  }

  /// Driver accepted the currently shown order.
  void acceptActive() {
    final order = _activeOrder;
    if (order == null) return;

    _autoRejectTimer?.cancel();
    _autoRejectTimer = null;
    _activeOrder = null;
    _pendingOrders.add(order);

    if (_pendingOrders.length < _maxOrdersPerTrip) {
      final compatible = _findCompatibleOrder();
      if (compatible != null) {
        // Brief pause before showing the next compatible order.
        _scheduleTimer?.cancel();
        _scheduleTimer = Timer(const Duration(seconds: 3), () {
          if (!isClosed) _showOrder(compatible);
        });
        return;
      }
    }

    _emitReadyForTrip();
  }

  /// Driver rejected (or auto-reject fired) the currently shown order.
  void rejectActive({bool auto = false}) {
    _autoRejectTimer?.cancel();
    _autoRejectTimer = null;
    _activeOrder = null;

    if (_pendingOrders.isNotEmpty) {
      // Already have accepted orders — start the trip with what we have.
      _emitReadyForTrip();
    } else {
      emit(const OrderQueueIdle());
      if (_enabled) _scheduleNext();
    }
  }

  // ── Internal ───────────────────────────────────────────────────────────────

  void _scheduleNext() {
    if (!_enabled) return;
    final delay = Duration(seconds: 15 + _rng.nextInt(16)); // 15–30 s
    _scheduleTimer?.cancel();
    _scheduleTimer = Timer(delay, () {
      if (!_enabled || isClosed) return;
      _showOrder(_pickRandom());
    });
  }

  void _showOrder(Order order) {
    _activeOrder = order;
    emit(OrderQueueShowingOrder(
      order: order,
      pendingOrders: List.unmodifiable(_pendingOrders),
    ));

    _autoRejectTimer?.cancel();
    _autoRejectTimer = Timer(const Duration(minutes: 2), () {
      rejectActive(auto: true);
    });
  }

  void _emitReadyForTrip() {
    final orders = List<Order>.from(_pendingOrders);
    _pendingOrders.clear();
    _enabled = false; // Pause — resumed by home screen after trip ends.
    emit(OrderQueueReadyForTrip(orders));
  }

  Order _pickRandom() {
    final all = _ordersRepo.getFixedOrders();
    return all[_rng.nextInt(all.length)];
  }

  /// Find a compatible order that can be added to the current pending list.
  Order? _findCompatibleOrder() {
    final all = List<Order>.from(_ordersRepo.getFixedOrders())..shuffle(_rng);
    for (final candidate in all) {
      if (_pendingOrders.any((p) => p.id == candidate.id)) continue;
      final result = _ordersRepo.combine(
        current: _pendingOrders,
        incoming: candidate,
      );
      if (result.allowed) return candidate;
    }
    return null;
  }

  @override
  Future<void> close() {
    _scheduleTimer?.cancel();
    _autoRejectTimer?.cancel();
    return super.close();
  }
}
