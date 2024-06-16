import 'dart:convert';

import 'package:emplanner/models/course.dart';
import 'package:emplanner/models/school_class.dart';
import 'package:emplanner/models/school_year.dart';
import 'package:emplanner/models/semester.dart';
import 'package:emplanner/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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

  static Future<List<SchoolYear>> getSchoolYears() async {
    String? token = await AuthService.getToken();
    try {
      final url =
          Uri.http('10.0.2.2:8000', 'api/school-years/get_all_school_years');
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

        List<dynamic> yearsDataList = responseBody['data'];
        List<SchoolYear> yearsList = [];

        for (var semester in yearsDataList) {
          SchoolYear year = SchoolYear.fromJson(semester);
          yearsList.add(year);
        }
        print(yearsList);
        return yearsList;
      } else {
        throw Exception('Failed to fetch years');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<bool> saveSemester(
    String id,
    String name,
    DateTime startDate,
    DateTime endDate,
  ) async {
    String? token = await AuthService.getToken();
    try {
      final url = Uri.http('10.0.2.2:8000', 'api/schedules/store_semester');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          "school_year_id": id,
          "name": name,
          'start_date': startDate.toIso8601String().split('T')[0],
          'end_date': startDate.toIso8601String().split('T')[0],
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to save semesters: ${response.reasonPhrase}');
        return false;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<bool> updateYear(String yearId, SchoolYear year) async {
    String? token = await AuthService.getToken();

    try {
      final url = Uri.http('10.0.2.2:8000', 'api/school-years/$yearId');
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(year.toJson()),
      );

      if (response.statusCode == 200) {
        return true; // Cập nhật thành công
      } else {
        print('Failed to update schoolYear: ${response.reasonPhrase}');
        return false; // Cập nhật không thành công
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Error: $e'); // Ném ngoại lệ nếu có lỗi xảy ra
    }
  }

  static Future<bool> saveClass(SchoolClass cl, String courseId) async {
    String? token = await AuthService.getToken();
    print('${cl.dayOfWeek} S');
    try {
      final url = Uri.http('10.0.2.2:8000', 'api/schedules/store_class');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          "course_id": courseId,
          "room": cl.room,
          "start_time": formatTimeOfDay(cl.startTime),
          "end_time": formatTimeOfDay(cl.endTime!),
          "day_of_week": cl.dayOfWeek,
          "date": cl.date == null
              ? null
              : DateFormat('yyyy-MM-dd').format(cl.date!),
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to save class: ${response.reasonPhrase}');
        return false;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<bool> saveCourse(Course cl) async {
    String? token = await AuthService.getToken();
    print(cl.toJson());
    try {
      final url = Uri.http('10.0.2.2:8000', 'api/schedules/store_course');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(cl.toJson()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to save course: ${response.reasonPhrase}');
        return false;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<bool> updateCourse(Course course) async {
    String? token = await AuthService.getToken();
    print(course.toJson());
    try {
      final url =
          Uri.http('10.0.2.2:8000', 'api/schedules/update_course/${course.id}');
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(course.toJson()),
      );

      if (response.statusCode == 200) {
        return true; // Cập nhật thành công
      } else {
        print('Failed to update Course: ${response.reasonPhrase}');
        return false; // Cập nhật không thành công
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Error: $e'); // Ném ngoại lệ nếu có lỗi xảy ra
    }
  }
}

String formatTimeOfDay(TimeOfDay tod) {
  final now = DateTime.now();
  final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
  final format = DateFormat('HH:mm'); // 'HH:mm' format
  return format.format(dt);
}
