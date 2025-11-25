import 'dart:convert';

import 'package:eventify/models/category_response.dart';
import 'package:http/http.dart' as http;

class CategoryService {
  
  static const String _baseUrl = 'https://eventify.iaknowhow.es/public/api';

  Future<CategoryResponse> getCategories(String token) async {
    Uri url = Uri.parse('$_baseUrl/categories');

    final response = await http.get(
      url,
      headers: {'Accept' : 'application/json', 'Authorization' : 'Bearer $token'}
    );

    final categoryResponse = CategoryResponse.fromJson(json.decode(response.body));
    return categoryResponse;

  }

}
