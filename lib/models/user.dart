class User {
  final String? id;
  final String email;
  final String password;
  final String? username;
  final String? token;
  final String? refreshToken; // Add this field
  final DateTime? createdAt;
  final dynamic profileImage; // Can be File, String (base64), or XFile
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
