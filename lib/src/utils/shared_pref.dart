import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static String authToken = '';

  static Future<void> save(String key, dynamic value) async {
    if(key == 'token') SharedPref.authToken = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(value));
  }

  static Future<dynamic> read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(key);

    return value == null? false:jsonDecode(value);
  }

  static Future<bool> exists(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }

  static Future<bool> deleteByKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final deleted = await prefs.remove(key);

    return deleted;
  }

  static Future<void> setAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString('token');

    SharedPref.authToken = value == null ? '' : jsonDecode(value);
  }

  static Future<bool> logOut() async {
    final prefs = await SharedPreferences.getInstance();
    final deleted = await prefs.remove('user');
    SharedPref.authToken = '';
    prefs.remove('token');
    
    return deleted;
  }

}