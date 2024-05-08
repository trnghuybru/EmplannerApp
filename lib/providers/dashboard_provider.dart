import 'dart:convert';

import 'package:emplanner/auth_service.dart';
import 'package:emplanner/models/class_dashboard.dart';
import 'package:emplanner/models/exam_dashboard.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardServices {
  Future<Map<String, dynamic>> getClassExam() async {
    String? token = await AuthService.getToken();

    try {
      final url = Uri.http('10.0.2.2:8000', 'api/dashboard/get_classes_exams');
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

        // Extract 'today' and 'tomorrow' data directly from responseBody
        Map<String, dynamic> todayData = responseBody['data']['today'];
        Map<String, dynamic> tomorrowData = responseBody['data']['tomorrow'];

        // Extract classes and exams for 'today' and 'tomorrow'
        List<ClassDashboard> todayClasses =
            (todayData['class'] as List<dynamic>)
                .map((json) => ClassDashboard.fromJson(json))
                .toList();
        List<ExamDashboard> todayExams = (todayData['exam'] as List<dynamic>)
            .map((json) => ExamDashboard.fromJson(json))
            .toList();
        List<ClassDashboard> tomorrowClasses =
            (tomorrowData['class'] as List<dynamic>)
                .map((json) => ClassDashboard.fromJson(json))
                .toList();
        List<ExamDashboard> tomorrowExams =
            (tomorrowData['exam'] as List<dynamic>)
                .map((json) => ExamDashboard.fromJson(json))
                .toList();

        return {
          'today': {
            'class': todayClasses,
            'exam': todayExams,
          },
          'tomorrow': {
            'class': tomorrowClasses,
            'exam': tomorrowExams,
          },
        };
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      print(e.toString());
    }
    return {};
  }

  Future<Map<String, dynamic>> getTodayDetail() async {
    String? token = await AuthService.getToken();

    try {
      final url = Uri.http('10.0.2.2:8000', 'api/dashboard/get_today_detail');
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

        Map<String, dynamic> data = responseBody['data'];

        int inCompletedTask = data['incompleted_task'];
        int completedTask = data['completed_task'];
        String cumulativeTime = data['cumulative_time'];

        return {
          'incompletedTask': inCompletedTask,
          'completedTask': completedTask,
          'cumulativeTime': cumulativeTime,
        };
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      print(e.toString());
    }
    return {};
  }
}

final dashboardProvider = Provider((ref) => DashboardServices());

final dashboardDataProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  return ref.watch(dashboardProvider).getClassExam();
});

final dashboardDetailProvider =
    FutureProvider<Map<String, dynamic>>((ref) async {
  return ref.watch(dashboardProvider).getTodayDetail();
});
