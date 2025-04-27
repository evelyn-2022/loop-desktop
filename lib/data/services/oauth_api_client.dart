import 'package:dio/dio.dart';
import 'package:loop/config/app_config.dart';
import 'package:loop/data/services/dio_api_handler.dart';
import 'package:loop/data/services/models/api_response.dart';
import 'package:loop/data/services/models/login_response.dart';

class OAuthApiClient {
  final Dio dio;

  OAuthApiClient({Dio? dioClient})
      : dio = dioClient ??
            Dio(BaseOptions(baseUrl: AppConfig.baseUrl));

  Future<ApiResponse<LoginResponse>> oauthLogin({
    required String provider,
    required String code,
    required String redirectUri,
  }) async {
    final body = {
      'provider': provider,
      'code': code,
      'redirectUri': redirectUri,
    };

    return handleDioRequest<LoginResponse>(
      dio.post('/auth/oauth-login', data: body),
      (data) => LoginResponse.fromJson(
          data as Map<String, dynamic>),
      () => LoginResponse.empty(),
    );
  }
}
