import 'package:shared_preferences/shared_preferences.dart';

class AuthTokenManager {
  static const _key = 'access_token';

  String? _cachedToken;

  Future<void> saveToken(String token) async {
    _cachedToken = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, token);
  }

  Future<String?> loadToken() async {
    if (_cachedToken != null) return _cachedToken;
    final prefs = await SharedPreferences.getInstance();
    _cachedToken = prefs.getString(_key);
    return _cachedToken;
  }

  Future<void> clearToken() async {
    _cachedToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
