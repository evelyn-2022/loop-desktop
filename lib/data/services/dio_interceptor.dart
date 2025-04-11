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
    final token = await tokenManager.loadToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err,
      ErrorInterceptorHandler handler) async {
    print('❌ Dio error: ${err.message}');
    if (err.response?.statusCode == 401) {
      print('🔁 Token expired, attempting refresh...');

      try {
        // Log the outgoing refresh request
        print('📤 Sending /auth/refresh request...');
        print(
            'authDio options.extra: ${authDio.options.extra}');
        print(
            'authDio options.headers: ${authDio.options.headers}');

        final response =
            await authDio.post('/auth/refresh');

        print(
            '✅ Refresh response status: ${response.statusCode}');
        print('✅ Refresh response data: ${response.data}');

        final newToken =
            response.data['data']['accessToken'];

        if (newToken != null) {
          await tokenManager.saveToken(newToken);

          final requestOptions = err.requestOptions;
          requestOptions.headers['Authorization'] =
              'Bearer $newToken';

          print(
              '🔁 Retrying original request with new token...');

          final retryResponse =
              await authDio.fetch(requestOptions);
          return handler.resolve(retryResponse);
        } else {
          print(
              '⚠️ No accessToken found in refresh response');
        }
      } catch (e, stack) {
        print('❌ Refresh token request failed: $e');
        print(stack);
        await tokenManager.clearToken();
      }
    }

    handler.next(err);
  }
}
