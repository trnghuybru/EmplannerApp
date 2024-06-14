import 'package:emplanner/models/exam.dart';
import 'package:emplanner/services/exam_sevice.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ExamsNotifier to fetch and manage list of exams
class ExamsNotifier extends StateNotifier<List<Exam>> {
  ExamsNotifier() : super(const []);

  Future<void> fetchExams() async {
    state = await ExamService.getAllExams();
  }
}

final examsStateNotifierProvider =
    StateNotifierProvider<ExamsNotifier, List<Exam>>(
  (ref) => ExamsNotifier(),
);

final examFutureProvider = FutureProvider((ref) async {
  await ref.read(examsStateNotifierProvider.notifier).fetchExams();
  return ref.watch(examsStateNotifierProvider);
});

final selectedExamDateProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});

final examFilterProvider = Provider<List<Exam>>((ref) {
  final selectedDate = ref.watch(selectedExamDateProvider);
  final exams = ref.watch(examsStateNotifierProvider);
  final isOverdueMode = ref.watch(examOverdueModeProvider);

  var filteredExams = exams.where((exam) {
    return exam.startDate == selectedDate;
  }).toList();

  if (isOverdueMode) {
    filteredExams =
        exams.where((exam) => exam.startDate.isBefore(DateTime.now())).toList();
  }

  return filteredExams;
});

class ExamOverdueModeNotifier extends StateNotifier<bool> {
  ExamOverdueModeNotifier() : super(false);

  void toggle() {
    state = !state;
  }
}

final examOverdueModeProvider =
    StateNotifierProvider<ExamOverdueModeNotifier, bool>((ref) {
  return ExamOverdueModeNotifier();
});
