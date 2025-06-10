class ApiResponse<T> {
  final bool success;
  final int statusCode;
  final String message;
  final T? data;

  ApiResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) create,
  ) {
    return ApiResponse(
      success: json['success'] ?? json['status'] == 'success',
      statusCode: json['statusCode'],
      message: json['message'] ?? '',
      data: create(json['data']),
    );
  }
}
