import 'package:emplanner/models/school_year.dart';
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

///

class YearNotifier extends StateNotifier<List<SchoolYear>> {
  YearNotifier() : super(const []);

  Future<void> fetchYears() async {
    state = await ScheduleService.getSchoolYears();
  }
}

final yearsStateNotifierProvider =
    StateNotifierProvider<YearNotifier, List<SchoolYear>>(
  (ref) => YearNotifier(),
);

final yearsFutureProvider = FutureProvider((ref) async {
  await ref.read(yearsStateNotifierProvider.notifier).fetchYears();
  return ref.watch(yearsStateNotifierProvider);
});
