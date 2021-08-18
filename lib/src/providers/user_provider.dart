import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:food_delivery/src/api/environment.dart';
import 'package:food_delivery/src/models/response_api_model.dart';
import 'package:food_delivery/src/models/user_model.dart';
import 'package:http/http.dart' as http;

class UserProvider {
  final String _url = Environment.apiDelivery;
  final String _api = 'api/users';
  late BuildContext context;

  void init(BuildContext context) {
    this.context = context;
  }

  Future<ResponseApi?> register(User user) async {
    try {
      Uri request = Uri.http(_url, '$_api/register');
      String body = json.encode(user);
      Map<String, String> headers = {'Content-type': 'application/json'};
      
      final response = await http.post(request, headers: headers, body: body);
      final data = json.decode(response.body);
      return ResponseApi.fromJson(data);

    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<ResponseApi?> login(String email, String password) async {
    try {
      Uri request = Uri.http(_url, '$_api/login');
      String body = json.encode({ 'email': email, 'password': password });
      Map<String, String> headers = {'Content-type': 'application/json'};

      final response = await http.post(request, headers: headers, body: body);
      final data = json.decode(response.body);
      return ResponseApi.fromJson(data);

    } catch (e) {
      print('Error $e');
      return null;
    }
  }

}
