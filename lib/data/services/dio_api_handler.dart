import 'package:dio/dio.dart';
import 'package:loop/data/services/models/api_response.dart';

Future<ApiResponse<T>> handleDioRequest<T>(
  Future<Response> future,
  T Function(Object? data) fromData,
  T Function() emptyBuilder,
) async {
  try {
    final response = await future;
    final jsonMap = response.data as Map<String, dynamic>;

    return ApiResponse.fromJson(
        jsonMap, (data) => fromData(data));
  } on DioException catch (e) {
    if (e.response != null) {
      final statusCode = e.response?.statusCode ?? 500;
      final responseData = e.response?.data;

      if (responseData is Map<String, dynamic>) {
        return ApiResponse.fromJson(
          responseData,
          (_) => emptyBuilder(),
        );
      } else {
        return ApiError<T>(
          status: 'ERROR',
          code: statusCode,
          message: 'Unexpected error format from server.',
        );
      }
    } else {
      return ApiError<T>(
        status: 'ERROR',
        code: 500,
        message: 'Could not connect to the server.',
      );
    }
  } catch (e) {
    return ApiError<T>(
      status: 'ERROR',
      code: 500,
      message: 'Unexpected error: ${e.toString()}',
    );
  }
}
