import 'dart:convert';

import 'package:eventify/models/auth_response.dart';
import 'package:http/http.dart' as http;

class UserService {
  static const String _baseUrl = 'https://eventify.iaknowhow.es/public/api';

  // /register
  Future<AuthResponse> register(
    String name,
    String email,
    String password,
    String confirmPassword,
    String role,
  ) async {
    Uri url = Uri.parse('$_baseUrl/register');

    final response = await http.post(
      url,
      body: {
        'name': name,
        'email': email,
        'password': password,
        'c_password': confirmPassword,
        'role': role,
      },
      headers: {'Accept': 'application/json'}
    );

    final authResponse = AuthResponse.fromJson(json.decode(response.body));

    return authResponse;
  }

  // /login
  Future<AuthResponse> login(String email, String password) async {
    Uri url = Uri.parse('$_baseUrl/login');

    final response = await http.post(
      url,
      body: {'email': email, 'password': password},
      headers: {'Accept': 'application/json'},
    );

    final authResponse = AuthResponse.fromJson(json.decode(response.body));

    return authResponse;
  }

  // /activate
  Future<AuthResponse> activate(int id, String token) async {
    Uri url = Uri.parse('$_baseUrl/activate');

    final response = await http.post(
      url,
      body: {'id': id},
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    final authResponse = AuthResponse.fromJson(json.decode(response.body));
    return authResponse;
  }

  // /deactivate
  Future<AuthResponse> deactivate(int id, String token) async {
    Uri url = Uri.parse('$_baseUrl/deactivate');

    final response = await http.post(
      url,
      body: {'id': id},
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    final authResponse = AuthResponse.fromJson(json.decode(response.body));
    return authResponse;
  }

  // /users
  Future<AuthResponse> getUsers(String token) async {
    Uri url = Uri.parse('$_baseUrl/users');

    final response = await http.get(
      url,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    final authResponse = AuthResponse.fromJson(json.decode(response.body));
    return authResponse;
  }

  // /deleteUser
  Future<AuthResponse> deleteUser(int id, String token) async {
    Uri url = Uri.parse('$_baseUrl/deleteUser');

    final response = await http.post(
      url,
      body: {'id': id},
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    final authResponse = AuthResponse.fromJson(json.decode(response.body));
    return authResponse;
  }

  // /updateUser
  Future<AuthResponse> updateUser(int id, String name, String token) async {
    Uri url = Uri.parse('$_baseUrl/updateUser');

    final response = await http.post(
      url,
      body: {'id': id, 'name': name},
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    final authResponse = AuthResponse.fromJson(json.decode(response.body));
    return authResponse;
  }
}
