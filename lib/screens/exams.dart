import 'package:emplanner/providers/exam_provider.dart';
import 'package:emplanner/services/exam_sevice.dart';
import 'package:emplanner/widgets/exam_dialog.dart';
import 'package:emplanner/widgets/exam_item.dart';
import 'package:emplanner/widgets/new_exam_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:emplanner/widgets/buttons/secondary_buttons.dart';
import 'package:emplanner/models/course.dart';
import 'package:emplanner/models/exam.dart';
import 'package:emplanner/providers/courses_provider.dart';
import 'package:emplanner/providers/dashboard_provider.dart';

class ExamsScreen extends ConsumerWidget {
  const ExamsScreen({super.key});

  void _openAddExamOverLay(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return const NewExamDialog();
      },
    );
  }

  void _deleteExam(String id) async {
    await ExamService.deleteExam(id);
  }

  void _showPopupDialog(BuildContext context, Exam exam) {
    ExamService.getExam(exam.id.toString()).then((exam) {
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return ExamDialog(exam: exam);
        },
      );
    }).catchError((error) {
      // Handle error if any
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(examFutureProvider);
    data.when(
        data: (data) {
          print(data.length);
        },
        error: (e, r) => throw Exception(e),
        loading: () {});
    final selectedDate = ref.watch(selectedExamDateProvider);
    final filteredExams = ref.watch(examFilterProvider);
    final isOverdueMode = ref.watch(examOverdueModeProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('MMM d, yyyy').format(DateTime.now()),
                    style: const TextStyle(
                      color: Color.fromARGB(255, 131, 131, 131),
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Today',
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  SecondaryButton(
                    icon: Icons.add_rounded,
                    title: const Text('Add Exam'),
                    onPressed: () {
                      _openAddExamOverLay(context);
                    },
                  ),
                  const SizedBox(width: 10),
                  ToggleButton(
                    isOverdueMode: isOverdueMode,
                  ),
                ],
              ),
            ],
          ),
        ),
        if (!isOverdueMode)
          Container(
            margin: const EdgeInsets.only(left: 20, bottom: 15),
            child: DatePicker(
              DateTime.now(),
              height: 90,
              width: 70,
              initialSelectedDate: selectedDate,
              selectionColor: const Color.fromARGB(255, 250, 187, 24),
              selectedTextColor: Colors.white,
              dateTextStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 73, 73, 73),
              ),
              onDateChange: (selectedDate) {
                data.when(
                    data: (exams) {
                      ref.read(selectedExamDateProvider.notifier).state =
                          selectedDate;
                    },
                    error: (e, r) {},
                    loading: () {});
              },
            ),
          ),
        Expanded(
          child: SizedBox(
            height: 200,
            child: filteredExams.isEmpty
                ? const Center(child: Text("No exams were found."))
                : ListView.builder(
                    itemCount: filteredExams.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          _showPopupDialog(context, filteredExams[index]);
                        },
                        child: Dismissible(
                          key: UniqueKey(),
                          direction: DismissDirection
                              .endToStart, // chỉ cho phép vuốt từ phải sang trái
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Delete',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Icon(Icons.cancel, color: Colors.white),
                              ],
                            ),
                          ),
                          confirmDismiss: (direction) async {
                            return await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Delete Exam'),
                                  content: const Text(
                                      'Are you sure you want to delete this exam?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(true);
                                      },
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          onDismissed: (direction) async {
                            _deleteExam(filteredExams[index].id.toString());
                            ref.refresh(dashboardDetailProvider);
                            await ref
                                .read(examsStateNotifierProvider.notifier)
                                .fetchExams();
                          },
                          child: ExamItem(exam: filteredExams[index]),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}

class ToggleButton extends ConsumerWidget {
  final bool isOverdueMode;

  const ToggleButton({super.key, required this.isOverdueMode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: Icon(
        isOverdueMode ? Icons.unpublished_outlined : Icons.done,
      ),
      onPressed: () {
        ref.read(examOverdueModeProvider.notifier).toggle();
      },
    );
  }
}
