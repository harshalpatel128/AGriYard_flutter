class PriceHistoryRecord {
  final String date;
  final int minPrice;
  final int avgPrice;
  final int maxPrice;

  PriceHistoryRecord({
    required this.date,
    required this.minPrice,
    required this.avgPrice,
    required this.maxPrice,
  });
}
