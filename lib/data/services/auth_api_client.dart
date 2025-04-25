import 'package:dio/dio.dart';

import 'package:loop/config/app_config.dart';
import 'package:loop/data/services/dio_api_handler.dart';
import 'package:loop/data/services/models/login_request.dart';
import 'package:loop/data/services/models/login_response.dart';
import 'package:loop/data/services/models/api_response.dart';
import 'package:loop/data/services/models/signup_request.dart';

class AuthApiClient {
  final Dio dio;

  AuthApiClient({Dio? dioClient})
      : dio = dioClient ??
            Dio(BaseOptions(baseUrl: AppConfig.baseUrl));

  Future<ApiResponse<LoginResponse>> login(
      LoginRequest request) async {
    return handleDioRequest<LoginResponse>(
      dio.post('/auth/login', data: request.toMap()),
      (data) => LoginResponse.fromJson(
          data as Map<String, dynamic>),
      () => LoginResponse.empty(),
    );
  }

  Future<ApiResponse<void>> logout(
      String refreshToken) async {
    return handleDioRequest<void>(
      dio.post(
        '/auth/logout',
        options: Options(headers: {
          'Authorization': 'Bearer $refreshToken'
        }),
      ),
      (_) {},
      () {},
    );
  }

  Future<ApiResponse<void>> signup(
      SignupRequest request) async {
    return handleDioRequest<void>(
      dio.post('/auth/signup', data: request.toMap()),
      (_) {},
      () {},
    );
  }

  Future<ApiResponse<void>> checkEmailRegistered(
      String email) async {
    return handleDioRequest<void>(
      dio.get(
        '/auth/check-email',
        queryParameters: {'email': email},
      ),
      (_) {},
      () {},
    );
  }

  Future<ApiResponse<void>> resendVerificationEmail(
      String email) async {
    return handleDioRequest<void>(
      dio.post(
        '/auth/resend-verification',
        data: {'email': email},
      ),
      (_) {},
      () {},
    );
  }

  Future<ApiResponse<void>> forgotPassword(
      String email) async {
    return handleDioRequest<void>(
      dio.post(
        '/auth/forgot-password',
        queryParameters: {'email': email},
      ),
      (_) {},
      () {},
    );
  }

  Future<ApiResponse<void>> verifyResetCode(
      String email, String code) async {
    return handleDioRequest<void>(
      dio.post(
        '/auth/verify-reset-code',
        data: {
          'email': email,
          'code': code,
        },
      ),
      (_) {},
      () {},
    );
  }
}
