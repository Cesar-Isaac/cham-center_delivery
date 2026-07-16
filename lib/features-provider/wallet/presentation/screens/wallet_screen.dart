import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../history/presentation/screens/history_screen.dart';
import '../../domain/entities/wallet_entry.dart';
import '../state/wallet_cubit.dart';

/// محفظة السائق — عرض الأرباح فقط (بدون سحب).
class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  static const String route = '/driver-wallet';

  static String _formatMoney(double value) {
    final String digits = value.toStringAsFixed(0);
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      buffer.write(digits[i]);
      final int remaining = digits.length - i - 1;
      if (remaining > 0 && remaining % 3 == 0) {
        buffer.write(',');
      }
    }
    return '${buffer.toString()} ل.س';
  }

  static String _formatTime(DateTime time) {
    final String hour =
    time.hour.toString().padLeft(2, '0');
    final String minute =
    time.minute.toString().padLeft(2, '0');
    return '$hour:$minute — ${time.day}/${time.month}/${time.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1220),
      appBar: AppBar(
        title: const Text('المحفظة'),
        backgroundColor: const Color(0xFF0B1220),
      ),
      body: BlocBuilder<WalletCubit, List<WalletEntry>>(
        builder: (context, entries) {
          final todayEntries =
          entries.where((e) => e.isToday).toList();

          final double todayTotal = todayEntries.fold(
            0.0,
                (sum, e) => sum + e.amount,
          );

          final double allTimeTotal = entries.fold(
            0.0,
                (sum, e) => sum + e.amount,
          );

          return CustomScrollView(
            slivers: [
              // ── بطاقة أرباح اليوم ─────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                sliver: SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.teal.shade400,
                          Colors.teal.shade800,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color:
                          Colors.teal.withValues(alpha: 0.35),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(9),
                              decoration: BoxDecoration(
                                color: Colors.white
                                    .withValues(alpha: 0.18),
                                borderRadius:
                                BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons
                                    .account_balance_wallet_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Text(
                                'أرباح اليوم',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Container(
                              padding:
                              const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white
                                    .withValues(alpha: 0.18),
                                borderRadius:
                                BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${todayEntries.length} طلب',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _formatMoney(todayTotal),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'عمولتك تُحتسب من كل طلب حسب مسافة التوصيل',
                          style: TextStyle(
                            color: Colors.white
                                .withValues(alpha: 0.75),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── إحصائيات إجمالية ──────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: Icons.payments_rounded,
                          label: 'إجمالي الأرباح',
                          value: _formatMoney(allTimeTotal),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          icon:
                          Icons.local_shipping_rounded,
                          label: 'الطلبات الموصلة',
                          value: '${entries.length}',
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              HistoryScreen.route,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── سجل الأرباح ───────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 22, 16, 10),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'سجل الأرباح',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Text(
                        '${entries.length} عملية',
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if (entries.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: _EmptyWallet(),
                )
              else
                SliverPadding(
                  padding:
                  const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        final entry = entries[index];

                        return Padding(
                          padding:
                          const EdgeInsets.only(bottom: 10),
                          child: _EarningTile(
                            entry: entry,
                            amountText:
                            '+ ${_formatMoney(entry.amount)}',
                            timeText:
                            _formatTime(entry.earnedAt),
                          ),
                        );
                      },
                      childCount: entries.length,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF141F33),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color:
              Colors.white.withValues(alpha: 0.06),
            ),
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon,
                      color: Colors.teal, size: 20),
                  const Spacer(),
                  if (onTap != null)
                    const Icon(
                      Icons.chevron_left_rounded,
                      color: Colors.white24,
                      size: 18,
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white38,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EarningTile extends StatelessWidget {
  const _EarningTile({
    required this.entry,
    required this.amountText,
    required this.timeText,
  });

  final WalletEntry entry;
  final String amountText;
  final String timeText;

  @override
  Widget build(BuildContext context) {
    final int ratePercent = (entry.rate * 100).round();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF141F33),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.teal.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.receipt_long_rounded,
              color: Colors.teal,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${entry.orderId} — ${entry.customerName}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${entry.distanceKm.toStringAsFixed(1)} كم • عمولة $ratePercent%',
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  timeText,
                  style: const TextStyle(
                    color: Colors.white24,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            amountText,
            style: const TextStyle(
              color: Colors.greenAccent,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyWallet extends StatelessWidget {
  const _EmptyWallet();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.account_balance_wallet_outlined,
              size: 64,
              color: Colors.white.withValues(alpha: 0.2),
            ),
            const SizedBox(height: 16),
            const Text(
              'لا توجد أرباح بعد',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'أوصل طلبات لتُضاف عمولتك هنا تلقائياً.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white38,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
