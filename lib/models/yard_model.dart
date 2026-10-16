class YardModel {
  final String id;
  final String name;
  final String city;
  final String address;
  final String contactNumber;
  final String totalShops;
  final String establishedYear;
  final String imageAsset;
  bool isFavorite;

  YardModel({
    required this.id,
    required this.name,
    required this.city,
    required this.address,
    required this.contactNumber,
    required this.totalShops,
    required this.establishedYear,
    required this.imageAsset,
    this.isFavorite = false,
  });

  YardModel copyWith({
    String? id,
    String? name,
    String? city,
    String? address,
    String? contactNumber,
    String? totalShops,
    String? establishedYear,
    String? imageAsset,
    bool? isFavorite,
  }) {
    return YardModel(
      id: id ?? this.id,
      name: name ?? this.name,
      city: city ?? this.city,
      address: address ?? this.address,
      contactNumber: contactNumber ?? this.contactNumber,
      totalShops: totalShops ?? this.totalShops,
      establishedYear: establishedYear ?? this.establishedYear,
      imageAsset: imageAsset ?? this.imageAsset,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
