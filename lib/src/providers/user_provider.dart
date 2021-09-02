import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:food_delivery/src/api/environment.dart';
import 'package:food_delivery/src/models/response_api_model.dart';
import 'package:food_delivery/src/models/user_model.dart';
import 'package:food_delivery/src/utils/shared_pref.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class UserProvider {
  final String _url = Environment.apiDelivery;
  final String _api = 'api/users';
  late BuildContext context;

  void init(BuildContext context) {
    this.context = context;
  }

  Future<Stream?> register(User user, File? image) async {
    try {
      Uri request = Uri.http(_url, '$_api/register');
      final body = http.MultipartRequest('POST', request);

      if (image != null) {
        body.files.add(http.MultipartFile(
          'image',
          http.ByteStream(image.openRead().cast()),
          await image.length(),
          filename: basename(image.path)
        ));
      }

      body.fields['user'] = jsonEncode(user);
      
      final response = await body.send();
      return response.stream.transform(utf8.decoder);

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

  Future<ResponseApi?> edit(String id, Map editUser) async {
    try {
      Uri request = Uri.http(_url, '$_api/$id');
      String body = json.encode(editUser);

      String token = await SharedPref.read('token');
      Map<String, String> headers = {'Content-type': 'application/json', 'Authorization': 'Bearer $token'};

      final response = await http.put(request, headers: headers, body: body);
      final data = json.decode(response.body);
      return ResponseApi.fromJson(data);

    } catch (e) {
      print('Error $e');
      return null;
    }
  }

  Future<Stream?> editProfileImage(String id, File? image) async {
    try {
      Uri request = Uri.http(_url, '$_api/image/$id');
      final body = http.MultipartRequest('PUT', request);

      if (image != null) {
        body.files.add(http.MultipartFile(
          'image',
          http.ByteStream(image.openRead().cast()),
          await image.length(),
          filename: basename(image.path)
        ));
      }
      
      String token = await SharedPref.read('token');
      body.headers['Authorization'] = 'Bearer $token';  

      final response = await body.send();
      return response.stream.transform(utf8.decoder);

    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

}
