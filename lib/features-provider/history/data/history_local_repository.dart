import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/entities/history_entry.dart';
import '../domain/repositories/history_repository.dart';

/// Persists delivery history to device storage via SharedPreferences.
/// Entries survive app restarts. Call [clear] to wipe them.
class HistoryLocalRepository implements HistoryRepository {
  HistoryLocalRepository({required SharedPreferences prefs})
    : _prefs = prefs,
      _cache = _decode(prefs);

  static const _key = 'delivery_history_v1';

  final SharedPreferences _prefs;
  final List<HistoryEntry> _cache;

  static List<HistoryEntry> _decode(SharedPreferences prefs) {
    final raw = prefs.getStringList(_key) ?? [];
    final entries = <HistoryEntry>[];
    for (final s in raw) {
      try {
        entries.add(HistoryEntry.fromJson(
          jsonDecode(s) as Map<String, dynamic>,
        ));
      } catch (_) {
        // Skip corrupted entries silently.
      }
    }
    return entries;
  }

  void _persist() {
    _prefs.setStringList(
      _key,
      _cache.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }

  @override
  void addEntry(HistoryEntry entry) {
    _cache.insert(0, entry);
    _persist();
  }

  @override
  List<HistoryEntry> getAll() => List.unmodifiable(_cache);

  @override
  void clear() {
    _cache.clear();
    _prefs.remove(_key);
  }
}
