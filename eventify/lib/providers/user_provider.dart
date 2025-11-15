import 'package:eventify/models/auth_response.dart';
import 'package:eventify/models/user.dart';
import 'package:eventify/services/user_service.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  final UserService userService;
  User? activeUser;
  String? errorMessage;
  bool loading = false;

  UserProvider(this.userService);

  Future<void> login(String email, String password) async {
    errorMessage = null;
    loading = true;
    notifyListeners();

    try {
      AuthResponse response = await userService.login(email, password);
      if (response.success) {
        activeUser = User.fromLoginJson(response.data);
      } else {
        errorMessage = '${response.message}: ${response.data['error']}';
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    activeUser = null;
    errorMessage = null;
    notifyListeners();
  }
}
