import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:loop/config/app_config.dart';
import 'package:loop/data/services/models/login_request.dart';
import 'package:loop/data/services/models/login_response.dart';
import 'package:loop/data/services/models/api_response.dart';

class AuthApiClient {
  final http.Client httpClient;

  AuthApiClient({http.Client? httpClient})
      : httpClient = httpClient ?? http.Client();

  Future<ApiResponse<LoginResponse>> login(
      LoginRequest request) async {
    final url = '${AppConfig.baseUrl}/auth/login';

    try {
      final response = await httpClient.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toMap()),
      );

      final jsonMap =
          jsonDecode(response.body) as Map<String, dynamic>;

      return ApiResponse.fromJson(
        jsonMap,
        (data) => LoginResponse.fromJson(
            data as Map<String, dynamic>),
      );
    } catch (e) {
      // This is only hit if something fails on the HTTP layer
      return ApiError<LoginResponse>(
        status: 'ERROR',
        code: 500,
        message:
            'Cannot connect to server. Please check your connection.',
      );
    }
  }
}
