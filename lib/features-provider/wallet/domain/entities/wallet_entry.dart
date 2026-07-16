/// ربح واحد مسجّل في المحفظة: عمولة السائق عن طلب أوصله.
class WalletEntry {
  final String orderId;
  final String customerName;
  final double orderPrice;
  final double distanceKm;

  /// نسبة العمولة المطبقة (مثال: 0.08 = %8).
  final double rate;

  /// قيمة العمولة = orderPrice × rate.
  final double amount;

  final DateTime earnedAt;

  const WalletEntry({
    required this.orderId,
    required this.customerName,
    required this.orderPrice,
    required this.distanceKm,
    required this.rate,
    required this.amount,
    required this.earnedAt,
  });

  bool get isToday {
    final now = DateTime.now();
    return earnedAt.year == now.year &&
        earnedAt.month == now.month &&
        earnedAt.day == now.day;
  }

  Map<String, dynamic> toJson() => {
    'orderId': orderId,
    'customerName': customerName,
    'orderPrice': orderPrice,
    'distanceKm': distanceKm,
    'rate': rate,
    'amount': amount,
    'earnedAt': earnedAt.toIso8601String(),
  };

  factory WalletEntry.fromJson(Map<String, dynamic> json) => WalletEntry(
    orderId: json['orderId'] as String,
    customerName: json['customerName'] as String? ?? '',
    orderPrice: (json['orderPrice'] as num).toDouble(),
    distanceKm: (json['distanceKm'] as num).toDouble(),
    rate: (json['rate'] as num).toDouble(),
    amount: (json['amount'] as num).toDouble(),
    earnedAt: DateTime.parse(json['earnedAt'] as String),
  );
}
