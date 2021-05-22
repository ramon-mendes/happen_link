import 'dart:convert';

import 'package:happen_link/apimodels/user.dart';
import 'package:http/http.dart' as http;

const API_URL = "happenlinkbackend.azurewebsites.net";

class API {
  static void logout() {}

  static Future<User> login(String email, String pwd) async {
    final queryParameters = {
      'email': email,
      'pwd': pwd,
    };
    final response = await http.get(Uri.https(API_URL, "api/user/login", queryParameters));

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }
}
