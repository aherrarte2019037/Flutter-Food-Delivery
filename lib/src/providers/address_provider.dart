import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:food_delivery/src/models/address_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:food_delivery/src/models/response_api_model.dart';
import 'package:food_delivery/src/utils/shared_pref.dart';
import 'package:logger/logger.dart';

class AddressProvider {
  final String _url = dotenv.env['APIDELIVERY']!;
  final String _mapsUrl = dotenv.env['APIMAPS']!;
  final String _api = 'api/users/address';
  final String _apiMaps = 'api/users/address';
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
      Logger().d('Error: $e');
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
      Logger().d('Error: $e');
      return null;
    }
  }

  Future getOrderDuration(LatLng origin, LatLng destination) async {
    try {
      Map <String, String> queryParams = {
        'origins': '${origin.latitude},${origin.longitude}',
        'destinations': '${destination.latitude},${destination.longitude}',
        'key': dotenv.env['APIKEYMAPS']!,
      };
      Uri request = Uri.https(_mapsUrl, _apiMaps, queryParams);

      final response = await http.get(request);
      final data = jsonDecode(response.body);

      Logger().d(data);
      return data;
      
    } catch (e) {
      Logger().d('Error: $e');
      return null;
    }
  }

}