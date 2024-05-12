import 'dart:convert';

import 'package:emplanner/auth_service.dart';
import 'package:emplanner/models/task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
}

class TasksNotifier extends StateNotifier<List<Task>> {
  TasksNotifier() : super(const []);

  Future<void> fetchTasks() async {
    final taskServices = TaskServices();
    state = await taskServices.getAllTasks();
  }

  void addTask(Task task) {
    state = [...state, task];
  }
}

final tasksStateNotifierProvider =
    StateNotifierProvider<TasksNotifier, List<Task>>(
  (ref) => TasksNotifier(),
);

final taskFutureProvider = FutureProvider((ref) async {
  final taskStateNotifier =
      await ref.read(tasksStateNotifierProvider.notifier).fetchTasks();
  return ref.watch(tasksStateNotifierProvider);
});
