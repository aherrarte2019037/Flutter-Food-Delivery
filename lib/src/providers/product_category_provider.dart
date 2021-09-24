import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
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

  Future<List<ProductCategory>> getAll() async {
    try {
      Uri request = Uri.http(_url, '$_api/all');
      
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': 'Bearer ${SharedPref.authToken}'
      };

      final response = await http.get(request, headers: headers);
      final data = jsonDecode(response.body);

      ResponseApi responseApi = ResponseApi.fromJson(data);
      List<ProductCategory> categories = ProductCategory.fromJsonList(responseApi.data);

      return categories;

    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  Future<List<ProductCategory>> getCategoriesWithProducts() async {
    try {
      Uri request = Uri.http(_url, '$_api/withProducts');
      
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': 'Bearer ${SharedPref.authToken}'
      };

      final response = await http.get(request, headers: headers);
      final data = jsonDecode(response.body);

      ResponseApi responseApi = ResponseApi.fromJson(data);
      List<ProductCategory> categories = ProductCategory.fromJsonList(responseApi.data);

      return categories;

    } catch (e) {
      print('Error: $e');
      return [];
    }
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

  Future<Stream?> createCategory(ProductCategory category, File? image) async {
    try {
      Uri request = Uri.http(_url, '$_api/');
      final body = http.MultipartRequest('POST', request);

      if (image != null) {
        body.files.add(http.MultipartFile(
          'image',
          http.ByteStream(image.openRead().cast()),
          await image.length(),
          filename: basename(image.path)
        ));
      }
      
      body.fields['category'] = jsonEncode(category);
      body.headers['Authorization'] = 'Bearer ${SharedPref.authToken}';
      
      final response = await body.send();
      return response.stream.transform(utf8.decoder);

    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

}