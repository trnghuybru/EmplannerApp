import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final baseUrl = '10.0.2.2:8000';

  Future<dynamic> register(String email, String password) async {
    try {
      var res = await http.post(Uri.http(baseUrl, 'api/register'), body: {});
    } finally {
      //
    }
  }

  Future<http.Response> login(String email, String password) async {
    try {
      var res = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(
          {
            'email': email,
            'password': password,
          },
        ),
      );

      return res;
    } finally {
      //
    }
  }

  static Future<void> setToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<String?> getId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('id');
  }
}
