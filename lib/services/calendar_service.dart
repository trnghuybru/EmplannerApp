import 'dart:convert';
import 'dart:io';

import 'package:emplanner/models/calendar_class.dart';
import 'package:emplanner/services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';

Future<Map<String, dynamic>> decodeJson(String jsonString) async {
  return compute(_decodeAndParse, jsonString);
}

Map<String, dynamic> _decodeAndParse(String jsonString) {
  return jsonDecode(jsonString);
}

class CalendarService {
  static Future<List<CalendarClass>> fetchClass() async {
    String? token = await AuthService.getToken();

    try {
      final url = Uri.http('10.0.2.2:8000', 'api/calendars/get_list_classes');

      const r = RetryOptions(maxAttempts: 3);

      final response = await r.retry(
        () async => await http.get(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
        retryIf: (e) => e is http.ClientException || e is SocketException,
      );

      if (response.statusCode == 200) {
        // Sử dụng compute để giải mã JSON trong một isolate riêng
        Map<String, dynamic> data = await decodeJson(response.body);
        List<dynamic> classDataList = data['data'];

        List<CalendarClass> classList = [];

        for (var classData in classDataList) {
          CalendarClass cl = CalendarClass.fromJson(classData);
          classList.add(cl);
        }

        return classList;
      } else {
        throw Exception(
            'Failed to load courses: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error: $e');
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
