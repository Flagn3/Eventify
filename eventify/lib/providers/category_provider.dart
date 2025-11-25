import 'package:eventify/models/category.dart';
import 'package:eventify/models/category_response.dart';
import 'package:eventify/providers/user_provider.dart';
import 'package:eventify/services/category_service.dart';
import 'package:flutter/material.dart';

class CategoryProvider extends ChangeNotifier {

  final CategoryService _categoryService = CategoryService();
  final UserProvider userProvider;

  List<Category> categories = [];
  bool isLoading = false;
  String? errorMessage;

  CategoryProvider(this.userProvider);

 // List of events
  Future<void> getEvents() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final token =  userProvider.activeUser?.rememberToken;   // User token

      if (token == null) {
        errorMessage = "No hay usuario autenticado.";
        return;
      }

      // call to CategoryService getCategories
      CategoryResponse response = await _categoryService.getCategories(token);

      if (response.success == true) {
        categories = response.data;
      } else {
        errorMessage = response.message;
      }
    } catch (e) {
      errorMessage = "Error inesperado: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

}