import 'package:shared_preferences/shared_preferences.dart';

class AuthTokenManager {
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  String? _cachedAccessToken;
  String? _cachedRefreshToken;

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    _cachedAccessToken = accessToken;
    _cachedRefreshToken = refreshToken;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);
  }

  Future<String?> loadAccessToken() async {
    if (_cachedAccessToken != null) {
      return _cachedAccessToken;
    }
    final prefs = await SharedPreferences.getInstance();
    _cachedAccessToken = prefs.getString(_accessTokenKey);
    return _cachedAccessToken;
  }

  Future<String?> loadRefreshToken() async {
    if (_cachedRefreshToken != null) {
      return _cachedRefreshToken;
    }
    final prefs = await SharedPreferences.getInstance();
    _cachedRefreshToken = prefs.getString(_refreshTokenKey);
    return _cachedRefreshToken;
  }

  Future<void> clearTokens() async {
    _cachedAccessToken = null;
    _cachedRefreshToken = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
  }
}
