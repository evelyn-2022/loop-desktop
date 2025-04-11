import 'package:flutter/material.dart';
import 'package:loop/domain/models/user.dart';
import 'package:loop/data/services/models/api_response.dart';
import 'package:loop/data/repositories/profile_repository.dart';

class ProfileViewModel extends ChangeNotifier {
  final ProfileRepository repository;

  User? _user;
  String? _error;
  bool _isLoading = false;

  User? get user => _user;
  String? get error => _error;
  bool get isLoading => _isLoading;

  ProfileViewModel({required this.repository});

  Future<void> loadProfile() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final response = await repository.fetchProfile();

    switch (response) {
      case ApiSuccess<User>():
        _user = response.data;
        break;
      case ApiError<User>():
        _error = response.message;
        print('Error: ${response.message}');
        break;
    }

    _isLoading = false;
    notifyListeners();
  }
}
