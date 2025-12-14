import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/product.dart';

class ProductService {
  static final String baseUrl =
      dotenv.env['BASE_URL'] ?? 'http://localhost:5081/api';

  // Fetch danh sách sản phẩm
  static Future<List<ProductItem>> fetchProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = json.decode(response.body);

      final List<dynamic>? data = jsonBody['data'];
      if (data == null) return []; // tránh null

      return data.map((e) => ProductItem.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}
