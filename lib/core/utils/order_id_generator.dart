String generateOrderId() {
  final now = DateTime.now();

  return now.microsecondsSinceEpoch.toString();
}