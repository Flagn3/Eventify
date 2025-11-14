class AuthResponse {
  bool? success;
  Map<String, dynamic>? data;
  String? message;

  AuthResponse({
    required this.success,
    required this.data,
    required this.message
  });

      factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
        success: json["success"],
        data: Map<String, dynamic>.from(json["data"]),
        message: json["message"],
    );

}