import '../entities/history_entry.dart';

abstract class HistoryRepository {
  void addEntry(HistoryEntry entry);
  List<HistoryEntry> getAll();
  void clear();
}
