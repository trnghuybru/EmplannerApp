import 'package:emplanner/models/task.dart';
import 'package:emplanner/services/task_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:emplanner/models/new_task.dart';

class TasksNotifier extends StateNotifier<List<Task>> {
  TasksNotifier() : super(const []);

  Future<void> fetchTasks() async {
    final taskServices = TaskServices();
    state = await taskServices.getAllTasks();
  }
}

final tasksStateNotifierProvider =
    StateNotifierProvider<TasksNotifier, List<Task>>(
  (ref) => TasksNotifier(),
);

final taskFutureProvider = FutureProvider((ref) async {
  await ref.read(tasksStateNotifierProvider.notifier).fetchTasks();
  return ref.watch(tasksStateNotifierProvider);
});
