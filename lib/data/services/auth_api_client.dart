import 'package:http/http.dart' as http;
import 'package:loop/config/app_config.dart';
import 'package:loop/data/services/models/login_request.dart';
import 'package:loop/data/services/models/login_response.dart';

class AuthApiClient {
  final http.Client httpClient;

  AuthApiClient({http.Client? httpClient})
      : httpClient = httpClient ?? http.Client();

  Future<LoginResponse> login(LoginRequest request) async {
    final url = '${AppConfig.baseUrl}/auth/login';
    final response = await httpClient.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: request.toJson(),
    );

    if (response.statusCode == 200) {
      return LoginResponse.fromJson(response.body);
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }
}
