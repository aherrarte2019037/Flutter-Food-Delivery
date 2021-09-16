import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:food_delivery/src/models/product_model.dart';
import 'package:http/http.dart' as http;
import 'package:food_delivery/src/api/environment.dart';
import 'package:food_delivery/src/models/response_api_model.dart';
import 'package:food_delivery/src/utils/shared_pref.dart';

class ProductProvider {
  final String _url = Environment.apiDelivery;
  final String _api = 'api/products';

  Future<ResponseApi?> getLatestProducts() async {
    try {
      Uri request = Uri.http(_url, '$_api/latest');

      Map<String, String> headers = {
        'Content-type' : 'application/json',
        'Authorization': 'Bearer ${SharedPref.authToken}'
      };

      final response = await http.get(request, headers: headers);
      final data = jsonDecode(response.body);

      ResponseApi responseApi = ResponseApi.fromJson(data);
      responseApi.data = Product.fromJsonList(responseApi.data);

      return responseApi;

    } catch (e) {
      print('Error: $e');
      return null;
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