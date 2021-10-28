import 'dart:convert';
import 'package:food_delivery/src/models/address_model.dart';
import 'package:http/http.dart' as http;
import 'package:food_delivery/src/api/environment.dart';
import 'package:food_delivery/src/models/response_api_model.dart';
import 'package:food_delivery/src/utils/shared_pref.dart';

class AddressProvider {
  final String _url = Environment.apiDelivery;
  final String _api = 'api/users/address';
  final Map<String, String> authHeaders = {
    'Content-type': 'application/json',
    'Authorization': 'Bearer ${SharedPref.authToken}'
  };

  Future<List<Address>> getAllByUser() async {
    try {
      Uri request = Uri.http(_url, _api);

      final response = await http.get(request, headers: authHeaders);
      final data = jsonDecode(response.body);

      ResponseApi responseApi = ResponseApi.fromJson(data);
      List<Address> addresses = Address.fromJsonList(responseApi.data);

      return addresses;

    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  Future<ResponseApi?> create(Address address) async {
    try {
      Uri request = Uri.http(_url, _api);
      String body = jsonEncode(address);

      final response = await http.post(request, body: body, headers: authHeaders);
      final data = jsonDecode(response.body);

      ResponseApi responseApi = ResponseApi.fromJson(data);
      if (responseApi.success!) responseApi.data = Address.fromJson(responseApi.data);

      return responseApi;

    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

}