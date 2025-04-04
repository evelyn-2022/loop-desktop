import 'package:loop/data/services/auth_api_client.dart';
import 'package:loop/data/services/auth_token_manager.dart';
import 'package:loop/data/services/models/login_request.dart';
import 'package:loop/data/services/models/login_response.dart';
import 'package:loop/data/services/models/api_response.dart';

class AuthRepository {
  final AuthApiClient apiClient;
  final AuthTokenManager tokenManager;

  AuthRepository({
    required this.apiClient,
    required this.tokenManager,
  });

  Future<ApiResponse<LoginResponse>> login(
    String email,
    String password,
  ) async {
    final loginRequest =
        LoginRequest(email: email, password: password);
    final response = await apiClient.login(loginRequest);

    if (response is ApiSuccess<LoginResponse>) {
      await tokenManager
          .saveToken(response.data!.accessToken);
    }

    return response;
  }
}
