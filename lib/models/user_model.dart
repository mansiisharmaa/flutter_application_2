class UserModel {
  final String id;
  final String name;
  final String email;
  final bool isOnline;
  final String avatarUrl;
  bool isBlocked;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.isOnline = true,
    required this.avatarUrl,
    this.isBlocked = false,
  });
}