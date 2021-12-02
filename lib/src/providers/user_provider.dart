import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:food_delivery/src/models/response_api_model.dart';
import 'package:food_delivery/src/models/user_model.dart';
import 'package:food_delivery/src/utils/shared_pref.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:path/path.dart';

class UserProvider {
  final String _url = dotenv.env['APIDELIVERY']!;
  final String _api = 'api/users';
  final Map<String, String> authHeaders = {
    'Content-type': 'application/json',
    'Authorization': 'Bearer ${SharedPref.authToken}'
  };

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
      Logger().d('Error: $e');
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
      Logger().d('Error: $e');
      return null;
    }
  }

  Future<ResponseApi?> edit(String id, Map editUser) async {
    try {
      Uri request = Uri.http(_url, '$_api/$id');
      String body = json.encode(editUser);

      final response = await http.put(request, headers: authHeaders, body: body);
      final data = json.decode(response.body);
      return ResponseApi.fromJson(data);

    } catch (e) {
      Logger().d('Error: $e');
      return null;
    }
  }

  Future<User?> getProfile() async {
    try {
      Uri request = Uri.http(_url, '$_api/authenticated');

      final response = await http.get(request, headers: authHeaders);
      final data = json.decode(response.body);

      ResponseApi responseApi = ResponseApi.fromJson(data);
      if (responseApi.success == true) {
        return User.fromJson(responseApi.data);

      } else {
        return null;
      }

    } catch (e) {
      Logger().d('Error: $e');
      return null;
    }
  }

  Future<List<User>> getByRole(String role) async {
    try {
      Uri request = Uri.http(_url, '$_api/role/$role');

      final response = await http.get(request, headers: authHeaders);
      final data = json.decode(response.body);

      ResponseApi responseApi = ResponseApi.fromJson(data);
      if (responseApi.success == true) {
        return User.fromJsonList(responseApi.data);

      } else {
        return [];
      }
      
    } catch (e) {
      Logger().d('Error: $e');
      return [];
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
      
      body.headers['Authorization'] = 'Bearer ${SharedPref.authToken}';  

      final response = await body.send();
      return response.stream.transform(utf8.decoder);

    } catch (e) {
      Logger().d('Error: $e');
      return null;
    }
  }

}
