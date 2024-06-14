import 'dart:convert';

import 'package:emplanner/models/course.dart';
import 'package:emplanner/models/exam.dart';
import 'package:emplanner/models/task.dart';
import 'package:emplanner/services/auth_service.dart';
import 'package:http/http.dart' as http;

class ExamService {
  static Future<List<Exam>> getAllExams() async {
    String? token = await AuthService.getToken();

    try {
      final url = Uri.http('10.0.2.2:8000', 'api/exams');
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
        List<dynamic> examDataList = responseBody['data'];

        List<Exam> examsList = [];

        for (var examData in examDataList) {
          Exam exam = Exam.fromJson(examData);
          print(exam.tasks);
          examsList.add(exam);
        }

        return examsList;
      } else {
        throw Exception('Failed to fetch exams');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<Exam> getExam(String examId) async {
    String? token = await AuthService.getToken();

    try {
      final url = Uri.http('10.0.2.2:8000', 'api/exams/$examId');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final Map<String, dynamic> examData = responseBody['data']['exam'];
        final List<dynamic> tasksData = responseBody['data']['tasks'];

        Exam exam = Exam(
          id: examData['id'],
          course: Course.fromJson(responseBody['data']['exam']['course']),
          name: examData['name'],
          startDate: DateTime.parse(examData['start_date']),
          startTime: examData['start_time'],
          duration: examData['duration'],
          room: examData['room'],
          tasks: tasksData.map((taskData) => Task.fromJson(taskData)).toList(),
        );

        return exam; // Successfully fetched and parsed exam
      } else {
        print('Failed to get exam: ${response.reasonPhrase}');
        throw Exception('Failed to get exam');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Error: $e'); // Throw exception if any error occurs
    }
  }

  static Future<bool> deleteExam(String examId) async {
    String? token = await AuthService.getToken();

    try {
      final url = Uri.http('10.0.2.2:8000', 'api/exams/$examId');
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to delete exam: ${response.reasonPhrase}');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Error: $e');
    }
  }

  static Future<bool> saveExam(Exam exam, String id) async {
    String? token = await AuthService.getToken();
    Map<String, dynamic> jsonData = exam.toJson();
    jsonData['course_id'] = id;
    print(jsonData['start_time']);
    try {
      final url = Uri.http('10.0.2.2:8000', 'api/exams');
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: json.encode(jsonData));

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to save exam: ${response.reasonPhrase}');
        return false;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
