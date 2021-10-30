import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path/path.dart';
import 'package:food_delivery/src/models/product_model.dart';
import 'package:http/http.dart' as http;
import 'package:food_delivery/src/models/response_api_model.dart';
import 'package:food_delivery/src/utils/shared_pref.dart';

class ProductProvider {
  final String _url = dotenv.env['APIDELIVERY']!;
  final String _api = 'api/products';
  final Map<String, String> authHeaders = {
    'Content-type': 'application/json',
    'Authorization': 'Bearer ${SharedPref.authToken}'
  };

  Future<ResponseApi?> getLatestProducts() async {
    try {
      Uri request = Uri.http(_url, '$_api/latest');

      final response = await http.get(request, headers: authHeaders);
      final data = jsonDecode(response.body);

      ResponseApi responseApi = ResponseApi.fromJson(data);
      responseApi.data = Product.fromJsonList(responseApi.data);

      return responseApi;

    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<List> productsGroupBy(String field) async {
    try {
      Uri request = Uri.http(_url, '$_api/groupBy/$field');

      final response = await http.get(request, headers: authHeaders);
      final data = jsonDecode(response.body);

      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi.data;

    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  Future<Stream?> createProduct(Product product, List<File> images) async {
    try {
      Uri request = Uri.http(_url, '$_api/');
      final body = http.MultipartRequest('POST', request);

      for (var image in images) {
        body.files.add(http.MultipartFile(
          'images',
          http.ByteStream(image.openRead().cast()),
          await image.length(),
          filename: basename(image.path)
        ));
      }

      body.fields['product'] = jsonEncode(product);
      body.headers['Authorization'] = 'Bearer ${SharedPref.authToken}';
      
      final response = await body.send();
      return response.stream.transform(utf8.decoder);
      
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

}