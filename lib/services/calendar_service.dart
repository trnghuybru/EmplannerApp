import 'dart:convert';

import 'package:emplanner/models/calendar_class.dart';
import 'package:emplanner/services/auth_service.dart';
import 'package:http/http.dart' as http;

class CalendarService {
  static Future<List<CalendarClass>> fetchClass() async {
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

  Future<CalendarClass> getDetailClass(String classId) async {
    String? token = await AuthService.getToken();

    try {
      final url =
          Uri.http('10.0.2.2:8000', 'api/calendars/get_detail_class/$classId');
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final Map<String, dynamic> classData = responseBody['data'];

        CalendarClass calendarClass = CalendarClass.fromJson(classData);
        print(calendarClass.toString());

        return calendarClass; // Cập nhật thành công
      } else {
        print('Failed to update task: ${response.reasonPhrase}');
        throw Exception('Failed to get task');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Error: $e'); // Ném ngoại lệ nếu có lỗi xảy ra
    }
  }
}
