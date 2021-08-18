import 'dart:convert';

ResponseApi responseApiFromJson(String str) => ResponseApi.fromJson(json.decode(str));
String responseApiToJson(ResponseApi data) => json.encode(data.toJson());

class ResponseApi {
  bool? success;
  String? message;
  Map? error;
  dynamic data;

  ResponseApi({
    this.success,
    this.message,
    this.error,
    this.data
  });

  ResponseApi.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    error   = json['error'];
    data    = json['data'];
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "error"  : error,
    "data"   : data
  };
}
