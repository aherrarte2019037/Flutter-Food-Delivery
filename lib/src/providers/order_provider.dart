import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:food_delivery/src/models/address_model.dart';
import 'package:food_delivery/src/models/order_model.dart';
import 'package:http/http.dart' as http;
import 'package:food_delivery/src/models/response_api_model.dart';
import 'package:food_delivery/src/utils/shared_pref.dart';

class OrderProvider {
  final String _url = dotenv.env['APIDELIVERY']!;
  final String _api = 'api/users/order';
  final Map<String, String> authHeaders = {
    'Content-type': 'application/json',
    'Authorization': 'Bearer ${SharedPref.authToken}'
  };

  Future<Order?> create(Address address) async {
    try {
      Uri request = Uri.http(_url, _api);
      String body = jsonEncode(address.id);

      final response = await http.post(request, body: body, headers: authHeaders);
      final data = jsonDecode(response.body);

      ResponseApi responseApi = ResponseApi.fromJson(data);
      if (responseApi.success!) return Order.fromJson(responseApi.data);
      
      return null;

    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

}