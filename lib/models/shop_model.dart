class ShopModel {
  final String id;
  final int number;
  final String name;
  final String phoneNumber;
  final String yardId;

  ShopModel({
    required this.id,
    required this.number,
    required this.name,
    required this.phoneNumber,
    this.yardId = 'rajkot',
  });

  ShopModel copyWith({
    String? id,
    int? number,
    String? name,
    String? phoneNumber,
    String? yardId,
  }) {
    return ShopModel(
      id: id ?? this.id,
      number: number ?? this.number,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      yardId: yardId ?? this.yardId,
    );
  }
}
