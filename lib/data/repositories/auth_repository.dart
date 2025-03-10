import 'package:loop/data/services/auth_api_client.dart';
import 'package:loop/data/services/models/login_request.dart';
import 'package:loop/data/services/models/login_response.dart';

class AuthRepository {
  final AuthApiClient apiClient;

  AuthRepository({required this.apiClient});

  Future<LoginResponse> login(
      String email, String password) async {
    final loginRequest =
        LoginRequest(email: email, password: password);
    return await apiClient.login(loginRequest);
  }
}
