import 'package:flutter/foundation.dart';
import 'package:loop/data/repositories/auth_repository.dart';
import 'package:loop/data/services/models/api_response.dart';
import 'package:loop/data/services/models/login_response.dart';
import 'package:loop/providers/auth_state.dart';

class OAuthViewModel extends ChangeNotifier {
  final AuthRepository authRepository;
  final AuthState authState;

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  OAuthViewModel({
    required this.authRepository,
    required this.authState,
  });

  Future<bool> oauthLogin({
    required String provider,
    required String code,
    required String redirectUri,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await authRepository.oauthLogin(
      provider: provider,
      code: code,
      redirectUri: redirectUri,
    );
    _isLoading = false;

    if (response is ApiSuccess<LoginResponse>) {
      final accessToken = response.data?.accessToken;

      if (accessToken != null) {
        authState.updateToken(accessToken);
      }

      notifyListeners();
      return true;
    } else if (response is ApiError) {
      _errorMessage = response.message;
      notifyListeners();
      return false;
    }
    return false;
  }

  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }
}
