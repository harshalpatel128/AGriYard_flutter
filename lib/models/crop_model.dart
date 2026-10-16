import 'price_history_model.dart';

class CropRate {
  final String id;
  final String name;
  final String gujaratiName;
  final String imageAsset;
  int arrivalBags;
  int totalQuantityKg;
  int minPrice;
  int avgPrice;
  int maxPrice;
  int changeAmount;
  double changePercentage;
  bool isRise;
  String lastUpdated;
  String priceUnit;
  bool isFavorite;
  List<PriceHistoryRecord> history;

  CropRate({
    required this.id,
    required this.name,
    required this.gujaratiName,
    required this.imageAsset,
    required this.arrivalBags,
    required this.totalQuantityKg,
    required this.minPrice,
    required this.avgPrice,
    required this.maxPrice,
    required this.changeAmount,
    required this.changePercentage,
    required this.isRise,
    required this.lastUpdated,
    this.priceUnit = '20 Kg',
    this.isFavorite = false,
    required this.history,
  });

  String get displayName => gujaratiName.isNotEmpty ? '$name ($gujaratiName)' : name;

  CropRate copyWith({
    String? id,
    String? name,
    String? gujaratiName,
    String? imageAsset,
    int? arrivalBags,
    int? totalQuantityKg,
    int? minPrice,
    int? avgPrice,
    int? maxPrice,
    int? changeAmount,
    double? changePercentage,
    bool? isRise,
    String? lastUpdated,
    String? priceUnit,
    bool? isFavorite,
    List<PriceHistoryRecord>? history,
  }) {
    return CropRate(
      id: id ?? this.id,
      name: name ?? this.name,
      gujaratiName: gujaratiName ?? this.gujaratiName,
      imageAsset: imageAsset ?? this.imageAsset,
      arrivalBags: arrivalBags ?? this.arrivalBags,
      totalQuantityKg: totalQuantityKg ?? this.totalQuantityKg,
      minPrice: minPrice ?? this.minPrice,
      avgPrice: avgPrice ?? this.avgPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      changeAmount: changeAmount ?? this.changeAmount,
      changePercentage: changePercentage ?? this.changePercentage,
      isRise: isRise ?? this.isRise,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      priceUnit: priceUnit ?? this.priceUnit,
      isFavorite: isFavorite ?? this.isFavorite,
      history: history ?? this.history,
    );
  }
}
