import 'dart:convert';

import 'package:emplanner/models/new_task.dart';
import 'package:emplanner/services/auth_service.dart';
import 'package:emplanner/models/task.dart';
import 'package:http/http.dart' as http;

class TaskServices {
  Future<List<Task>> getAllTasks() async {
    String? token = await AuthService.getToken();

    try {
      final url = Uri.http('10.0.2.2:8000', 'api/tasks');
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

        List<dynamic> taskDataList = responseBody['data'];
        List<Task> tasksList = [];

        for (var taskData in taskDataList) {
          Task task = Task.fromJson(taskData);
          tasksList.add(task);
        }

        return tasksList;
      } else {
        throw Exception('Failed to fetch tasks');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<bool> saveTask(NewTask task) async {
    String? token = await AuthService.getToken();

    try {
      final url = Uri.http('10.0.2.2:8000', 'api/tasks');
      print(json.encode(task.toJson()));
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: json.encode(task.toJson()));

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to save task: ${response.reasonPhrase}');
        return false;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<bool> deleteTask(String taskId) async {
    String? token = await AuthService.getToken();

    try {
      final url = Uri.http('10.0.2.2:8000', 'api/tasks/$taskId');
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return true; // Xóa thành công
      } else {
        print('Failed to delete task: ${response.reasonPhrase}');
        return false; // Xóa không thành công
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Error: $e'); // Ném ngoại lệ nếu có lỗi xảy ra
    }
  }
}
