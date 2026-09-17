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
}
