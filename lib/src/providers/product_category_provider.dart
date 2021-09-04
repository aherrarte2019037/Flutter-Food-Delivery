import 'dart:convert';
import 'package:food_delivery/src/utils/shared_pref.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:food_delivery/src/api/environment.dart';
import 'package:food_delivery/src/models/product_category_model.dart';
import 'package:food_delivery/src/models/response_api_model.dart';

class ProductCategoryProvider {
  final String _url = Environment.apiDelivery;
  final String _api = 'api/products/categories';
  late BuildContext context;

  void init(BuildContext context) {
    this.context = context;
  }

  Future<ResponseApi?> getLatestCategories() async {
    try {
      Uri request = Uri.http(_url, '$_api/latest');
      
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': 'Bearer ${SharedPref.authToken}'
      };

      final response = await http.get(request, headers: headers);
      final data = jsonDecode(response.body);

      ResponseApi responseApi = ResponseApi.fromJson(data);
      responseApi.data = ProductCategory.fromJsonList(responseApi.data);

      return responseApi;

    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<ResponseApi?> createCategory(ProductCategory category) async {
    try {
      Uri request = Uri.http(_url, '$_api/');
      String body = jsonEncode(category);

      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': 'Bearer ${SharedPref.authToken}'
      };

      final response = await http.post(request, headers: headers, body: body);
      final data = jsonDecode(response.body);

      return ResponseApi.fromJson(data);
      
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

}