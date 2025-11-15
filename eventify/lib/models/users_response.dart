import 'package:eventify/models/user.dart';

class UsersResponse {
  final bool success;
  final List<User> data;
  final String message;

  UsersResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  factory UsersResponse.fromJson(Map<String, dynamic> json) => UsersResponse(
    success: json["success"],
    data: (json["data"] as List)
        .map((userJson) => User.fromUsersJson(userJson))
        .toList(),
    message: json["message"],
  );
}
