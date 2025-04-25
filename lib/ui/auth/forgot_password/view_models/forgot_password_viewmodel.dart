import 'package:flutter/material.dart';
import 'package:loop/data/repositories/auth_repository.dart';
import 'package:loop/data/services/models/api_response.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  final AuthRepository authRepository;
  String? _email;
  String? _code;
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  String? get email => _email;
  String? get code => _code;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  ForgotPasswordViewModel({required this.authRepository});

  Future<bool> requestPasswordReset(String email) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    _email = email;

    final response =
        await authRepository.forgotPassword(email);

    _isLoading = false;

    if (response is ApiSuccess) {
      _successMessage =
          'A reset code has been sent to your email.';
      notifyListeners();
      return true;
    } else if (response is ApiError) {
      _errorMessage = response.message;
      notifyListeners();
      return false;
    }
    return false;
  }

  Future<bool> verifyResetCode(String code) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    _code = code;

    final response =
        await authRepository.verifyResetCode(_email!, code);

    _isLoading = false;

    if (response is ApiSuccess) {
      _successMessage = 'Code verified successfully.';
      notifyListeners();
      return true;
    } else if (response is ApiError) {
      _errorMessage = response.message;
      notifyListeners();
      return false;
    }
    return false;
  }

  // Future<void> resendResetCode() async {
  //   _isLoading = true;
  //   _errorMessage = null;
  //   _successMessage = null;
  //   notifyListeners();

  //   final response = await authRepository
  //       .resendResetCode();

  //   _isLoading = false;

  //   if (response is ApiSuccess) {
  //     _successMessage = 'Reset code has been resent.';
  //     notifyListeners();
  //   } else if (response is ApiError) {
  //     _errorMessage = response.message;
  //     notifyListeners();
  //   }
  // }

  Future<bool> resetPassword(String newPassword) async {
    if (_email == null || _code == null) {
      _errorMessage = 'Missing email or code.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    final response = await authRepository.resetPassword(
      _email!,
      _code!,
      newPassword,
    );

    _isLoading = false;

    if (response is ApiSuccess) {
      _successMessage =
          'Password has been reset successfully.';
      notifyListeners();
      return true;
    } else if (response is ApiError) {
      _errorMessage = response.message;
      notifyListeners();
      return false;
    }
    return false;
  }

  // Clear any error messages
  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  // Clear any success messages
  void clearSuccess() {
    if (_successMessage != null) {
      _successMessage = null;
      notifyListeners();
    }
  }
}
