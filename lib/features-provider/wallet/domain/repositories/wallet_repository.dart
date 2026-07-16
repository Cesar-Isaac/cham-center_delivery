import '../entities/wallet_entry.dart';

abstract class WalletRepository {
  void addEntry(WalletEntry entry);

  List<WalletEntry> getAll();

  void clear();
}
