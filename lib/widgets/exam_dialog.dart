import 'package:emplanner/models/exam.dart';
import 'package:emplanner/providers/dashboard_provider.dart';
import 'package:emplanner/providers/exam_provider.dart';
import 'package:emplanner/services/exam_sevice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ExamDialog extends ConsumerWidget {
  final Exam exam;

  const ExamDialog({Key? key, required this.exam}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    exam.tasks!.isEmpty ? null : print(exam.tasks!.toList());
    return AlertDialog(
      contentPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              exam.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: 8),
                Text(DateFormat('HH:mm - dd/MM/yyyy').format(exam.startDate)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.book, size: 16),
                const SizedBox(width: 8),
                Text(exam.course!.name),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16),
                const SizedBox(width: 8),
                Text('${exam.duration} minutes'),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.room, size: 16),
                const SizedBox(width: 8),
                Text(exam.room),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Revision task',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            exam.tasks!.isEmpty
                ? const Text('This exam has no incomplete revision tasks.')
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: exam.tasks!
                        .map((task) => Card(
                              margin: const EdgeInsets.all(8.0),
                              child: ListTile(
                                leading: const Icon(Icons.assignment,
                                    color: Colors.amber),
                                title: Text(task.name ?? 'No name'),
                                subtitle: Text(task.endDate!
                                    .toIso8601String()
                                    .split('T')[0]),
                                trailing: const Icon(
                                    Icons.check_box_outline_blank_rounded,
                                    color: Colors.amber),
                              ),
                            ))
                        .toList(),
                  ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.grey),
          onPressed: () async {
            await ExamService.deleteExam(exam.id.toString());
            ref.refresh(dashboardDetailProvider);
            await ref.read(examsStateNotifierProvider.notifier).fetchExams();
            Navigator.of(context).pop();
          },
        ),
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.grey),
          onPressed: () {
            // Add your edit function here
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.grey,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
