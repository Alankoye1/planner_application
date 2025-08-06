import 'dart:ui';

class User {
  final String? id;
  final String? username;
  final String password;
  final String email;
  final DateTime createdAt;
  final String? token;
  final Image? profileImage;
  final String? profileBio;

  User({
    this.id,
    required this.email,
    required this.password,
    this.username,
    this.profileImage,
    this.profileBio,
    DateTime? createdAt,
    this.token,
  }) : createdAt = createdAt ?? DateTime.now();
}
