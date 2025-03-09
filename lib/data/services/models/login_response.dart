import 'dart:convert';

class LoginResponse {
  final String token;
  final String message;

  LoginResponse(
      {required this.token, required this.message});

  factory LoginResponse.fromMap(Map<String, dynamic> map) {
    return LoginResponse(
      token: map['token'] ?? '',
      message: map['message'] ?? '',
    );
  }

  factory LoginResponse.fromJson(String source) =>
      LoginResponse.fromMap(json.decode(source));
}
