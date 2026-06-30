import '../domain/entities/history_entry.dart';
import '../domain/repositories/history_repository.dart';

/// In-memory history: lives for the session, cleared when the app exits.
class HistoryInMemoryRepository implements HistoryRepository {
  final List<HistoryEntry> _entries = [];

  @override
  void addEntry(HistoryEntry entry) => _entries.insert(0, entry);

  @override
  List<HistoryEntry> getAll() => List.unmodifiable(_entries);

  @override
  void clear() => _entries.clear();
}
