class UserModel {
  final String id;
  final String name;
  final String phoneNumber;
  final String email;
  final String role;
  final String? createdAt;
  bool isActive;
  bool isBlocked;

  UserModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
    this.role = 'Farmer',
    this.createdAt,
    this.isActive = true,
    this.isBlocked = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phoneNumber': phoneNumber,
    'email': email,
    'role': role,
    'createdAt': createdAt,
    'isActive': isActive,
    'isBlocked': isBlocked,
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id']?.toString() ?? '',
    name: json['name']?.toString() ?? '',
    phoneNumber: json['phoneNumber']?.toString() ?? '',
    email: json['email']?.toString() ?? '',
    role: json['role']?.toString() ?? 'Farmer',
    createdAt: json['createdAt']?.toString(),
    isActive: json['isActive'] ?? true,
    isBlocked: json['isBlocked'] ?? false,
  );
}
