import 'package:dio/dio.dart';

import 'package:loop/config/app_config.dart';
import 'package:loop/data/services/dio_api_handler.dart';
import 'package:loop/data/services/models/login_request.dart';
import 'package:loop/data/services/models/login_response.dart';
import 'package:loop/data/services/models/api_response.dart';

class AuthApiClient {
  final Dio dio;

  AuthApiClient({Dio? dioClient})
      : dio = dioClient ?? Dio();

  Future<ApiResponse<LoginResponse>> login(
      LoginRequest request) async {
    final url = '${AppConfig.baseUrl}/auth/login';

    return handleDioRequest<LoginResponse>(
      dio.post(url, data: request.toMap()),
      (data) => LoginResponse.fromJson(
          data as Map<String, dynamic>),
      () => LoginResponse.empty(),
    );
  }

  Future<ApiResponse<LoginResponse>> refreshToken() async {
    final url = '${AppConfig.baseUrl}/auth/refresh';

    return handleDioRequest<LoginResponse>(
      dio.post(url),
      (data) => LoginResponse.fromJson(
          data as Map<String, dynamic>),
      () => LoginResponse.empty(),
    );
  }
}
