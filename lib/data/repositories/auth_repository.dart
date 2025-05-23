import 'package:loop/data/services/auth_api_client.dart';
import 'package:loop/data/services/auth_token_manager.dart';
import 'package:loop/data/services/models/login_request.dart';
import 'package:loop/data/services/models/login_response.dart';
import 'package:loop/data/services/models/api_response.dart';
import 'package:loop/data/services/models/signup_request.dart';
import 'package:loop/data/services/oauth_api_client.dart';

class AuthRepository {
  final AuthApiClient apiClient;
  final OAuthApiClient oauthApiClient;
  final AuthTokenManager tokenManager;

  AuthRepository({
    required this.apiClient,
    required this.oauthApiClient,
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
      await tokenManager.saveTokens(
          accessToken: response.data!.accessToken,
          refreshToken: response.data!.refreshToken);
    }

    return response;
  }

  Future<ApiResponse<void>> logout() async {
    final refreshToken =
        await tokenManager.loadRefreshToken();
    if (refreshToken == null) {
      return ApiError<void>(
          code: 401,
          message: 'No refresh token found',
          status: 'ERROR');
    }

    final response = await apiClient.logout(refreshToken);
    if (response is ApiSuccess) {
      await tokenManager.clearTokens();
    }
    return response;
  }

  Future<ApiResponse<void>> signup(String email,
      String password, String username) async {
    final signupRequest = SignupRequest(
        email: email,
        password: password,
        username: username);
    final response = await apiClient.signup(signupRequest);

    return response;
  }

  Future<bool> isEmailTaken(String email) async {
    final response =
        await apiClient.checkEmailRegistered(email);

    if (response is ApiSuccess) {
      return false;
    } else if (response is ApiError &&
        response.code == 409) {
      return true;
    } else {
      throw Exception(
          'Unexpected error: ${response.message}');
    }
  }

  Future<ApiResponse<void>> resendVerificationEmail(
      String email) {
    return apiClient.resendVerificationEmail(email);
  }

  Future<ApiResponse<void>> forgotPassword(
      String email) async {
    return apiClient.forgotPassword(email);
  }

  Future<ApiResponse<void>> verifyResetCode(
      String email, String code) async {
    return apiClient.verifyResetCode(email, code);
  }

  Future<ApiResponse<void>> resetPassword(
    String email,
    String code,
    String newPassword,
  ) async {
    return apiClient.resetPassword(
      email: email,
      code: code,
      newPassword: newPassword,
    );
  }

  Future<ApiResponse<LoginResponse>> oauthLogin({
    required String provider,
    required String code,
    required String redirectUri,
  }) async {
    final response = await oauthApiClient.oauthLogin(
      provider: provider,
      code: code,
      redirectUri: redirectUri,
    );

    if (response is ApiSuccess<LoginResponse>) {
      await tokenManager.saveTokens(
        accessToken: response.data!.accessToken,
        refreshToken: response.data!.refreshToken,
      );
    }

    return response;
  }
}
