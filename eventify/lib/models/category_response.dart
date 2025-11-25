import 'package:eventify/models/category.dart';

class CategoryResponse {

  final bool success;
  final List<Category> data;
  final String message;

  CategoryResponse({
    required this.success,
    required this.data,
    required this.message
  });

  factory CategoryResponse.fromJson(Map<String, dynamic> json) => CategoryResponse(
    success: json['success'], 
    data: (json['data'] as List)
    .map((categoryJson) => Category.fromCategoriesJson(categoryJson))
    .toList(), 
    message: json['message']
  );

}