class LoginResponse {
  final int userId;
  final String accessToken;
  final String refreshToken;

  LoginResponse({
    required this.userId,
    required this.accessToken,
    required this.refreshToken,
  });

  factory LoginResponse.fromJson(
      Map<String, dynamic> json) {
    return LoginResponse(
      userId: json['userId'] as int,
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }

  factory LoginResponse.empty() {
    return LoginResponse(
        userId: 0, accessToken: '', refreshToken: '');
  }
}
