import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/history_entry.dart';
import '../../domain/repositories/history_repository.dart';
import '../../../driver/domain/entities/trip.dart';

class HistoryCubit extends Cubit<List<HistoryEntry>> {
  final HistoryRepository _repo;

  HistoryCubit({required HistoryRepository repo})
    : _repo = repo,
      super(repo.getAll());

  void recordCompletedTrip(Trip trip) {
    final entry = HistoryEntry(trip: trip, completedAt: DateTime.now());
    _repo.addEntry(entry);
    emit(_repo.getAll());
  }

  void reload() => emit(_repo.getAll());
}
