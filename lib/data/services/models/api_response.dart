sealed class ApiResponse<T> {
  final String status;
  final int code;
  final String message;
  final T? data;

  const ApiResponse({
    required this.status,
    required this.code,
    required this.message,
    this.data,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) {
    final status = json['status'] as String;
    final code = json['code'] as int;
    final message = json['message'] as String;
    final rawData = json['data'];

    final parsedData =
        rawData != null ? fromJsonT(rawData) : null;

    if (status == 'SUCCESS') {
      return ApiSuccess<T>(
        status: status,
        code: code,
        message: message,
        data: parsedData,
      );
    } else {
      return ApiError<T>(
        status: status,
        code: code,
        message: message,
        data: parsedData,
      );
    }
  }
}

final class ApiSuccess<T> extends ApiResponse<T> {
  const ApiSuccess({
    required super.status,
    required super.code,
    required super.message,
    super.data,
  });
}

final class ApiError<T> extends ApiResponse<T> {
  const ApiError({
    required super.status,
    required super.code,
    required super.message,
    super.data,
  });
}
