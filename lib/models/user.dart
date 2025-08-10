import 'dart:ui';

class User {
  final String? id;
  final String email;
  final String password;
  final String? username;
  final String? token;
  final String? refreshToken; // Add this field
  final DateTime? createdAt;
  final Image? profileImage;
  final String? profileBio;

  User({
    this.createdAt,
    this.id,
    required this.email,
    required this.password,
    this.username,
    this.profileImage,
    this.profileBio,
    this.token,
    this.refreshToken,
  });
}
