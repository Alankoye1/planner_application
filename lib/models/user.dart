class User {
  final String? id;
  final String? username;
  final String password;
  final String email;
  final DateTime createdAt;
  final String? token;

  User({
    this.id,
    required this.email,
    required this.password,
    this.username,
    DateTime? createdAt,
    this.token,
  }) : createdAt = createdAt ?? DateTime.now();
}
