import 'package:flutter/material.dart';
import 'package:loop/data/repositories/auth_repository.dart';
import 'package:loop/data/services/models/api_response.dart';

class SignUpViewModel extends ChangeNotifier {
  final AuthRepository authRepository;

  bool _isLoading = false;
  bool _isSendingEmail = false;
  bool _canResend = true;
  String? _errorMessage;
  String? _successMessage;

  bool get isLoading => _isLoading;
  bool get isSendingEmail => _isSendingEmail;
  bool get canResend => _canResend;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  SignUpViewModel({
    required this.authRepository,
  });

  Future<bool> checkEmail(String email) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    final response = await authRepository.apiClient
        .checkEmailRegistered(email);

    _isLoading = false;

    if (response is ApiSuccess) {
      return false;
    } else if (response is ApiError &&
        response.code == 409) {
      return true;
    } else {
      _errorMessage = response.message;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signup(String email, String password,
      String username) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    final response = await authRepository.signup(
        email, password, username);
    _isLoading = false;

    if (response is ApiSuccess) {
      _successMessage = 'Sign Up Successful';
      notifyListeners();
      return true;
    } else if (response is ApiError) {
      _errorMessage = response.message;
      notifyListeners();
      return false;
    }

    return false;
  }

  Future<void> resendVerificationEmail(String email) async {
    if (!_canResend) return;

    _canResend = false;
    _isLoading = true;
    _isSendingEmail = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    final response =
        await authRepository.resendVerificationEmail(email);

    _isSendingEmail = false;
    Future.delayed(const Duration(seconds: 5), () {
      _canResend = true;
      notifyListeners();
    });

    if (response is ApiSuccess) {
      _successMessage = 'Verification email sent';
      notifyListeners();
    } else if (response is ApiError) {
      _errorMessage = response.message;
      notifyListeners();
    }
  }

  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  void clearSuccess() {
    if (_successMessage != null) {
      _successMessage = null;
      notifyListeners();
    }
  }
}
