import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:loop/config/app_config.dart';
import 'package:loop/data/services/auth_token_manager.dart';
import 'package:loop/domain/models/decoded_user.dart';

class AuthState extends ChangeNotifier {
  bool isLoggedIn = false;
  DecodedUser? currentUser;

  Future<void> loadInitialAuthState(
      AuthTokenManager tokenManager) async {
    final accessToken =
        await tokenManager.loadAccessToken();
    final refreshToken =
        await tokenManager.loadRefreshToken();

    if (accessToken != null &&
        !JwtDecoder.isExpired(accessToken)) {
      final payload = JwtDecoder.decode(accessToken);
      currentUser = DecodedUser.fromTokenPayload(payload);
      isLoggedIn = true;
    } else if (refreshToken != null) {
      final authDio =
          Dio(BaseOptions(baseUrl: AppConfig.baseUrl));
      try {
        final response = await authDio.post(
          '/auth/refresh',
          data: {"refreshToken": refreshToken},
        );

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
          final payload = JwtDecoder.decode(newAccessToken);
          currentUser =
              DecodedUser.fromTokenPayload(payload);
          isLoggedIn = true;
        }
      } catch (e) {
        currentUser = null;
        isLoggedIn = false;
      }
    } else {
      currentUser = null;
      isLoggedIn = false;
    }

    notifyListeners();
  }

  void updateToken(String token) {
    final payload = JwtDecoder.decode(token);
    currentUser = DecodedUser.fromTokenPayload(payload);
    isLoggedIn = true;
    notifyListeners();
  }

  void clear() {
    currentUser = null;
    isLoggedIn = false;
    notifyListeners();
  }
}
