import 'package:flutter/material.dart';
import 'package:loop/data/repositories/auth_repository.dart';
import 'package:loop/data/services/models/api_response.dart';
import 'package:loop/data/services/models/login_response.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthRepository authRepository;

  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  LoginViewModel({required this.authRepository});

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response =
        await authRepository.login(email, password);

    _isLoading = false;

    if (response is ApiSuccess<LoginResponse>) {
      final loginData = response.data;
      // TODO: Save token or userId
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

  void clearSuccess() {
    if (_successMessage != null) {
      _successMessage = null;
      notifyListeners();
    }
  }
}
