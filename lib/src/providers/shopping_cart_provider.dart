import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:food_delivery/src/models/product_model.dart';
import 'package:food_delivery/src/models/shopping_cart_item_model.dart';
import 'package:food_delivery/src/models/shopping_cart_model.dart';
import 'package:food_delivery/src/utils/shared_pref.dart';
import 'package:http/http.dart' as http;
import 'package:food_delivery/src/models/response_api_model.dart';

class ShoppingCartProvider {
  final String _url = dotenv.env['APIDELIVERY']!;
  final String _api = 'api/users/cart';
  final Map<String, String> authHeaders = {
    'Content-type': 'application/json',
    'Authorization': 'Bearer ${SharedPref.authToken}'
  };

  Future<List<ShoppingCartItem>> getProductsPurchased() async {
    try {
      Uri request = Uri.http(_url, '$_api/purchased');
      
      Map<String, String> authHeaders = {
        'Content-type': 'application/json',
        'Authorization': 'Bearer ${SharedPref.authToken}'
      };

      final response = await http.get(request, headers: authHeaders);
      final data = jsonDecode(response.body);

      ResponseApi responseApi = ResponseApi.fromJson(data);
      List<ShoppingCartItem> purchased = ShoppingCartItem.fromJsonList(responseApi.data);

      return purchased;

    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  Future<ShoppingCart?> getUserShoppingCart() async {
    try {
      Uri request = Uri.http(_url, _api);

      final response = await http.get(request, headers: authHeaders);
      final data = jsonDecode(response.body);

      ResponseApi responseApi = ResponseApi.fromJson(data);
      ShoppingCart cart = ShoppingCart.fromJson(responseApi.data);
      return cart;

    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<ShoppingCart?> addProductToShoppingCart(Product product, int quantity) async {
    try {
      Uri request = Uri.http(_url, _api);
      String body = jsonEncode({ 'product': product.id, 'quantity': quantity });

      final response = await http.put(request, headers: authHeaders, body: body);
      final data = jsonDecode(response.body);

      ResponseApi responseApi = ResponseApi.fromJson(data);
      ShoppingCart cart = ShoppingCart.fromJson(responseApi.data);
      
      return cart;

    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<ShoppingCart?> deleteProductFromShoppingCart(Product product, int quantity) async {
    try {
      Uri request = Uri.http(_url, '$_api/remove');
      String body = jsonEncode({ 'product': product.id, 'quantity': quantity });

      final response = await http.put(request, headers: authHeaders, body: body);
      final data = jsonDecode(response.body);

      ResponseApi responseApi = ResponseApi.fromJson(data);
      ShoppingCart cart = ShoppingCart.fromJson(responseApi.data);
      
      return cart;

    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

}