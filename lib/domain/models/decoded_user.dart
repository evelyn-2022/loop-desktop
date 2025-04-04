class DecodedUser {
  final int userId;
  final String email;
  final String username;
  final bool isAdmin;
  final String? profileUrl;

  DecodedUser({
    required this.userId,
    required this.email,
    required this.username,
    required this.isAdmin,
    this.profileUrl,
  });

  factory DecodedUser.fromTokenPayload(
      Map<String, dynamic> payload) {
    return DecodedUser(
      userId: int.parse(payload['sub']),
      email: payload['email'],
      username: payload['username'],
      isAdmin: payload['isAdmin'] ?? false,
      profileUrl: payload['profileUrl'],
    );
  }
}
