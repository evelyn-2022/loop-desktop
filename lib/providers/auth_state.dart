import 'package:flutter/foundation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:loop/data/services/auth_token_manager.dart';
import 'package:loop/domain/models/decoded_user.dart';

class AuthState extends ChangeNotifier {
  bool isLoggedIn = false;
  DecodedUser? currentUser;

  Future<void> loadInitialAuthState(
      AuthTokenManager tokenManager) async {
    final token = await tokenManager.loadAccessToken();

    if (token != null && !JwtDecoder.isExpired(token)) {
      final payload = JwtDecoder.decode(token);
      currentUser = DecodedUser.fromTokenPayload(payload);
      isLoggedIn = true;
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
