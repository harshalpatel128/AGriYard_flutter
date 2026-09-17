class UserModel {
  final String id;
  final String name;
  final String phoneNumber;
  final String email;
  bool isActive;
  bool isBlocked;

  UserModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
    this.isActive = true,
    this.isBlocked = false,
  });
}
