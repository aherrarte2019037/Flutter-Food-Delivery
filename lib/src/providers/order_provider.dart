import 'dart:convert';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:food_delivery/src/models/order_model.dart';
import 'package:http/http.dart' as http;
import 'package:food_delivery/src/models/response_api_model.dart';
import 'package:food_delivery/src/utils/shared_pref.dart';
import 'package:logger/logger.dart';

class OrderProvider {
  final String _url = dotenv.env['APIDELIVERY']!;
  final String _api = 'api/users/order';
  final Map<String, String> authHeaders = {
    'Content-type': 'application/json',
    'Authorization': 'Bearer ${SharedPref.authToken}'
  };

  Future<ResponseApi?> create(String addressId) async {
    try {
      Uri request = Uri.http(_url, _api);
      String body = jsonEncode({ 'address': addressId });

      final response = await http.post(request, body: body, headers: authHeaders);
      final data = jsonDecode(response.body);

      ResponseApi responseApi = ResponseApi.fromJson(data);
      if (responseApi.success!) responseApi.data = Order.fromJson(responseApi.data);
      
      return responseApi;

    } catch (e) {
      Logger().d('Error: $e');
      return null;
    }
  }

  Future<ResponseApi?> assignDelivery(String orderId, String deliveryId) async {
    try {
      Uri request = Uri.http(_url, '$_api/$orderId/delivery');
      String body = jsonEncode({ 'delivery': deliveryId });

      final response = await http.put(request, body: body, headers: authHeaders);
      final data = jsonDecode(response.body);

      ResponseApi responseApi = ResponseApi.fromJson(data);
      if (responseApi.success!) responseApi.data = Order.fromJson(responseApi.data);
      
      return responseApi;
      
    } catch (e) {
      Logger().d('Error: $e');
      return null;
    }
  }

  Future<ResponseApi?> editStatus(String orderId, OrderStatus status) async {
    try {
      Uri request = Uri.http(_url, '$_api/$orderId');
      String body = jsonEncode({ 'status': EnumToString.convertToString(status) });

      final response = await http.put(request, body: body, headers: authHeaders);
      final data = jsonDecode(response.body);

      ResponseApi responseApi = ResponseApi.fromJson(data);
      if (responseApi.success!) responseApi.data = Order.fromJson(responseApi.data);
      
      return responseApi;
      
    } catch (e) {
      Logger().d('Error: $e');
      return null;
    }
  }

  Future<int> getPurchasedCount() async {
    try {
      Uri request = Uri.http(_url, '$_api/count/purchased');

      final response = await http.get(request, headers: authHeaders);
      final data = jsonDecode(response.body);

      ResponseApi responseApi = ResponseApi.fromJson(data);      
      return responseApi.data ?? 0;

    } catch (e) {
      Logger().d('Error: $e');
      return 0;
    }
  }

  Future<Map<String, List<Order>>> getOrdersGroupedByStatus() async {
    try {
      Uri request = Uri.http(_url, '$_api/groupBy/status');

      final response = await http.get(request, headers: authHeaders);
      final data = jsonDecode(response.body);

      ResponseApi responseApi = ResponseApi.fromJson(data);
      if (!responseApi.success!) return {};

      Map<String, List<Order>> orders = {
        for (var item in responseApi.data.keys) item: Order.fromJsonList(responseApi.data[item]),
      };

      return orders;
      
    } catch (e) {
      Logger().d('Error: $e');
      return {};
    }
  }

}