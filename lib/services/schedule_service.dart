import 'dart:convert';

import 'package:emplanner/models/semester.dart';
import 'package:emplanner/services/auth_service.dart';
import 'package:http/http.dart' as http;

class ScheduleService {
  static Future<List<Semester>> getAllSemesters() async {
    String? token = await AuthService.getToken();

    try {
      final url = Uri.http('10.0.2.2:8000', 'api/schedules/get_all_semesters');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);

        List<dynamic> semestersDataList = responseBody['data'];
        List<Semester> semesterList = [];

        for (var semester in semestersDataList) {
          Semester task = Semester.fromJson(semester);
          semesterList.add(task);
        }

        print(semesterList.toString());

        return semesterList;
      } else {
        throw Exception('Failed to fetch semesters');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<bool> saveYears(DateTime startDate, DateTime endDate) async {
    String? token = await AuthService.getToken();

    try {
      final url = Uri.http('10.0.2.2:8000', 'api/school-years');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'start_date': startDate.toIso8601String(),
          'end_date': endDate.toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to save years: ${response.reasonPhrase}');
        return false;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
