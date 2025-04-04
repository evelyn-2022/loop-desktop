import 'package:flutter/foundation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:loop/domain/models/decoded_user.dart';

class AuthState extends ChangeNotifier {
  bool isLoggedIn = false;
  DecodedUser? currentUser;

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
