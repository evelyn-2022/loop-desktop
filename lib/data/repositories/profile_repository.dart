import 'package:loop/domain/models/user.dart';
import 'package:loop/data/services/models/api_response.dart';
import 'package:loop/data/services/profile_api_client.dart';

class ProfileRepository {
  final ProfileApiClient apiClient;

  ProfileRepository({required this.apiClient});

  Future<ApiResponse<User>> fetchProfile() =>
      apiClient.getProfile();
}
