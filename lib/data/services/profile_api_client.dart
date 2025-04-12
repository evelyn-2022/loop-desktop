import 'package:dio/dio.dart';
import 'package:loop/data/services/models/api_response.dart';
import 'package:loop/domain/models/user.dart';
import 'package:loop/data/services/dio_api_handler.dart';

class ProfileApiClient {
  final Dio dio;

  ProfileApiClient({required this.dio});

  Future<ApiResponse<User>> getProfile() {
    return handleDioRequest<User>(
      dio.get('/users/me',
          options: Options(extra: {'requiresAuth': true})),
      (data) => User.fromJson(data as Map<String, dynamic>),
      () => User.empty(),
    );
  }
}
