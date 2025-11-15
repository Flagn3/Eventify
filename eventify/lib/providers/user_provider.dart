import 'package:eventify/models/auth_response.dart';
import 'package:eventify/models/user.dart';
import 'package:eventify/models/users_response.dart';
import 'package:eventify/services/user_service.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  final UserService userService;
  User? activeUser;
  String? errorMessage;
  bool loading = false;
  List<User> userList = [];

  UserProvider(this.userService);

  //login
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

  //logout
  Future<void> logout() async {
    activeUser = null;
    errorMessage = null;
    notifyListeners();
  }

  //register
  Future<void> register(
    String name,
    String email,
    String password,
    String confirmPassword,
    String role,
  ) async {
    errorMessage = null;
    loading = true;
    notifyListeners();

    try {
      AuthResponse response = await userService.register(
        name,
        email,
        password,
        confirmPassword,
        role,
      );
      if (!response.success) {
        errorMessage = '${response.message}: ${response.data['error']}';
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  //activate/deactivate
  Future<void> editActivation(int id, bool actived) async {
    errorMessage = null;
    loading = true;
    notifyListeners();

    try {
      AuthResponse response;

      if (activeUser == null || activeUser!.rememberToken == null) {
        errorMessage = 'User not logged or invalid token';
        loading = false;
        notifyListeners();
        return;
      }

      if (actived) {
        response = await userService.deactivate(id, activeUser!.rememberToken!);
      } else {
        response = await userService.activate(id, activeUser!.rememberToken!);
      }
      if (response.success) {
        await getUsers();
      }

      if (!response.success) {
        errorMessage = '${response.message}: ${response.data['error']}';
      }
      // else?
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  //get users
  Future<void> getUsers() async {
    errorMessage = null;
    loading = true;
    // notifyListeners();

    try {
      if (activeUser == null || activeUser!.rememberToken == null) {
        errorMessage = 'User not logged or invalid token';
        loading = false;
        notifyListeners();
        return;
      }

      UsersResponse response = await userService.getUsers(
        activeUser!.rememberToken!,
      );

      if (response.success) {
        userList = response.data;
      } else {
        errorMessage = response.message;
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  //delete
  Future<void> deleteUser(int id) async {
    errorMessage = null;
    loading = true;
    notifyListeners();

    try {
      if (activeUser == null || activeUser!.rememberToken == null) {
        errorMessage = 'User not logged or invalid token';
        loading = false;
        notifyListeners();
        return;
      }
      AuthResponse response = await userService.deleteUser(
        id,
        activeUser!.rememberToken!,
      );

      if (!response.success) {
        errorMessage = '${response.message}: ${response.data['error']}';
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  //update
  Future<void> updateUser(int id, String name) async {
    errorMessage = null;
    loading = true;
    notifyListeners();

    try {
      if (activeUser == null || activeUser!.rememberToken == null) {
        errorMessage = 'User not logged or invalid token';
        loading = false;
        notifyListeners();
        return;
      }

      AuthResponse response = await userService.updateUser(
        id,
        name,
        activeUser!.rememberToken!,
      );

      if (!response.success) {
        errorMessage = '${response.message}: ${response.data['error']}';
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
