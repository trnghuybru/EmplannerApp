import 'package:emplanner/models/task.dart';
import 'package:emplanner/services/task_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TasksNotifier extends StateNotifier<List<Task>> {
  TasksNotifier() : super(const []);

  Future<void> fetchTasks() async {
    state = await TaskServices.getAllTasks();
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
//FOR FILTER

final selectedDateProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});

final taskFilterProvider = Provider<List<Task>>((ref) {
  final selectedDate = ref.watch(selectedDateProvider);
  final tasks = ref.watch(tasksStateNotifierProvider);

  final filteredTasks = tasks.where((task) {
    return task.endDate == selectedDate;
  }).toList();

  filteredTasks.sort((a, b) {
    if (a.status == 1 && b.status == 0) return 1;
    if (a.status == 0 && b.status == 1) return -1;
    return 0;
  });

  return filteredTasks;
});
