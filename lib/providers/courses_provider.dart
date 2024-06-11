import 'package:emplanner/models/course.dart';
import 'package:emplanner/services/course_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CoursesNotifier extends StateNotifier<List<Course>> {
  CoursesNotifier() : super(const []);

  Future<void> fetchTasks() async {
    state = await CoursesServices.getCourses();
  }
}

final coursesStateNotifierProvider =
    StateNotifierProvider<CoursesNotifier, List<Course>>(
  (ref) => CoursesNotifier(),
);

final coursesFutureProvider = FutureProvider((ref) async {
  await ref.read(coursesStateNotifierProvider.notifier).fetchTasks();
  return ref.watch(coursesStateNotifierProvider);
});
