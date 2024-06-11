import 'dart:convert';

import 'package:emplanner/services/auth_service.dart';
import 'package:emplanner/models/course.dart';
import 'package:http/http.dart' as http;

class CoursesServices {
  static Future<List<Course>> getCourses() async {
    String? token = await AuthService.getToken();

    try {
      final url = Uri.http('10.0.2.2:8000', 'api/tasks/get_courses');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<Course> courseList = _parseCourseList(response.body);
        return courseList;
      } else {
        throw Exception('Failed to fetch tasks');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static List<Course> _parseCourseList(String responseBody) {
    final parsed = json.decode(responseBody)['data'] as List<dynamic>;
    return parsed
        .map<Course>((json) => Course(
              id: json['id'],
              name: json['name'],
              colorCode: json['color_code'],
              teacher: json['teacher'],
              startDate: DateTime.parse(json['start_date']),
              endDate: DateTime.parse(json['end_date']),
            ))
        .toList();
  }
}
