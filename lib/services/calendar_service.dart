import 'dart:convert';

import 'package:emplanner/models/calendar_class.dart';
import 'package:emplanner/services/auth_service.dart';
import 'package:http/http.dart' as http;

class CalendarService {
  Future<List<CalendarClass>> fetchClass() async {
    String? token = await AuthService.getToken();

    try {
      final url = Uri.http('10.0.2.2:8000', 'api/calendars/get_list_classes');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body)['data'];
        return data.map((json) => CalendarClass.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load courses');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
