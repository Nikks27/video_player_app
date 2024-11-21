import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class ApiHelper {
  Future<Map<String,dynamic>> fetchApi() async {
    String api = 'https://raw.githubusercontent.com/bikashthapa01/myvideos-android-app/master/data.json';
    Uri uri = Uri.parse(api);
    Response response = await http.get(uri);

    if(response.statusCode == 200)
    {
      final Map<String,dynamic> data = jsonDecode(response.body);
      return data;
    }
    else
    {
      return{};
    }
  }
}