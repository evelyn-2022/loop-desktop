class LoginResponse {
  final int userId;
  final String accessToken;

  LoginResponse({
    required this.userId,
    required this.accessToken,
  });

  factory LoginResponse.fromJson(
      Map<String, dynamic> json) {
    return LoginResponse(
      userId: json['userId'] as int,
      accessToken: json['accessToken'] as String,
    );
  }

  factory LoginResponse.empty() {
    return LoginResponse(userId: 0, accessToken: '');
  }
}
