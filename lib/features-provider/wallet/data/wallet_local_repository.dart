import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/entities/wallet_entry.dart';
import '../domain/repositories/wallet_repository.dart';

/// Persists driver earnings to device storage via SharedPreferences.
/// Entries survive app restarts. Call [clear] to wipe them.
class WalletLocalRepository implements WalletRepository {
  WalletLocalRepository({required SharedPreferences prefs})
      : _prefs = prefs,
        _cache = _decode(prefs);

  static const _key = 'driver_wallet_v1';

  final SharedPreferences _prefs;
  final List<WalletEntry> _cache;

  static List<WalletEntry> _decode(SharedPreferences prefs) {
    final raw = prefs.getStringList(_key) ?? [];
    final entries = <WalletEntry>[];
    for (final s in raw) {
      try {
        entries.add(WalletEntry.fromJson(
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
  void addEntry(WalletEntry entry) {
    _cache.insert(0, entry);
    _persist();
  }

  @override
  List<WalletEntry> getAll() => List.unmodifiable(_cache);

  @override
  void clear() {
    _cache.clear();
    _prefs.remove(_key);
  }
}
