import 'package:dio/dio.dart';
import 'package:loop/data/services/auth_token_manager.dart';

class DioInterceptor extends Interceptor {
  final AuthTokenManager tokenManager;
  final Dio authDio;

  DioInterceptor({
    required this.tokenManager,
    required this.authDio,
  });

  @override
  Future<void> onRequest(RequestOptions options,
      RequestInterceptorHandler handler) async {
    final token = await tokenManager.loadAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err,
      ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        final refreshToken =
            await tokenManager.loadRefreshToken();
        if (refreshToken == null) {
          await tokenManager.clearTokens();
          return handler.next(err);
        }

        final response = await authDio.post(
          '/auth/refresh',
          data: {'refreshToken': refreshToken},
          options: Options(
            headers: {'Content-Type': 'application/json'},
          ),
        );

        print('Refresh token response: ${response.data}');

        final newAccessToken =
            response.data['data']['accessToken'];
        final newRefreshToken =
            response.data['data']['refreshToken'];

        if (newAccessToken != null &&
            newRefreshToken != null) {
          await tokenManager.saveTokens(
            accessToken: newAccessToken,
            refreshToken: newRefreshToken,
          );

          final requestOptions = err.requestOptions;
          requestOptions.headers['Authorization'] =
              'Bearer $newAccessToken';

          final retryResponse =
              await authDio.fetch(requestOptions);
          return handler.resolve(retryResponse);
        }
      } catch (e) {
        await tokenManager.clearTokens();
      }
    }

    handler.next(err);
  }
}
