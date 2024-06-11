import 'package:emplanner/models/semester.dart';
import 'package:emplanner/services/schedule_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SemestersNotifier extends StateNotifier<List<Semester>> {
  SemestersNotifier() : super(const []);

  Future<void> fetchSemesters() async {
    state = await ScheduleService.getAllSemesters();
  }
}

final semesterStateNotifierProvider =
    StateNotifierProvider<SemestersNotifier, List<Semester>>(
  (ref) => SemestersNotifier(),
);

final semesterFutureProvider = FutureProvider((ref) async {
  await ref.read(semesterStateNotifierProvider.notifier).fetchSemesters();
  return ref.watch(semesterStateNotifierProvider);
});
