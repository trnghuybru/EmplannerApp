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
  final isOverdueMode = ref.watch(overdueModeProvider);

  var filteredTasks = tasks.where((task) {
    return task.endDate == selectedDate;
  }).toList();

  // Sắp xếp các task theo trạng thái
  filteredTasks.sort((a, b) {
    if (a.status == 1 && b.status == 0) return 1; // Chưa done đến done
    if (a.status == 0 && b.status == 1) return -1; // Done đến chưa done
    return 0;
  });

  // Nếu đang ở chế độ hiển thị overdue
  if (isOverdueMode) {
    // Lọc ra các task overdue và không hiển thị thanh DatePicker
    filteredTasks =
        tasks.where((task) => task.endDate!.isBefore(DateTime.now())).toList();
  }

  return filteredTasks;
});

class OverdueModeNotifier extends StateNotifier<bool> {
  OverdueModeNotifier() : super(false);

  void toggle() {
    state = !state;
  }
}

final overdueModeProvider =
    StateNotifierProvider<OverdueModeNotifier, bool>((ref) {
  return OverdueModeNotifier();
});
