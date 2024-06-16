import 'dart:ffi';

import 'package:emplanner/models/course.dart';
import 'package:emplanner/models/exam.dart';
import 'package:emplanner/providers/dashboard_provider.dart';
import 'package:emplanner/providers/exam_provider.dart';
import 'package:emplanner/services/exam_sevice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:emplanner/providers/courses_provider.dart'; // Ensure the correct import

class NewExamDialog extends ConsumerStatefulWidget {
  const NewExamDialog({super.key});

  @override
  ConsumerState<NewExamDialog> createState() => _NewExamDialogState();
}

class _NewExamDialogState extends ConsumerState<NewExamDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roomController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();

  String? _selectedSubject;

  @override
  void dispose() {
    _nameController.dispose();
    _roomController.dispose();
    _durationController.dispose();
    _dateController.dispose();
    _startTimeController.dispose();
    super.dispose();
  }

  void _createExam() async {
    Exam exam = Exam(
      name: _nameController.text,
      startDate: DateFormat('MM/dd/yyyy').parse(_dateController.text),
      startTime: _startTimeController.text,
      duration: int.parse(_durationController.text),
      room: _roomController.text,
    );
    await ExamService.saveExam(exam, _selectedSubject!);
  }

  @override
  Widget build(BuildContext context) {
    final courses = ref.watch(coursesFutureProvider);

    return courses.when(
      data: (courses) {
        return AlertDialog(
          title: const Text('Create New Exam'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Course',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedSubject,
                  items: courses.map((subject) {
                    return DropdownMenuItem(
                      value: subject.id.toString(),
                      child: Text(subject.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSubject = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _roomController,
                  decoration: const InputDecoration(
                    labelText: 'Room Number',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _dateController,
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      String formattedDate =
                          DateFormat('MM/dd/yyyy').format(pickedDate);
                      setState(() {
                        _dateController.text = formattedDate;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _startTimeController,
                        decoration: const InputDecoration(
                          labelText: 'Start Time',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.access_time),
                        ),
                        readOnly: true,
                        onTap: () async {
                          TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (pickedTime != null) {
                            // Định dạng thời gian sử dụng DateFormat
                            String formattedTime = DateFormat.Hm().format(
                              DateTime(
                                  0, 1, 1, pickedTime.hour, pickedTime.minute),
                            );
                            setState(() {
                              _startTimeController.text = formattedTime;
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: _durationController,
                        decoration: const InputDecoration(
                          labelText: 'Duration (mins)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 250, 187, 24),
              ),
              onPressed: () {
                _createExam();
                ref.read(examsStateNotifierProvider.notifier).fetchExams();
                ref.refresh(dashboardDataProvider);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Created New School Year!'),
                    duration: Duration(seconds: 2),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
      error: (e, r) => AlertDialog(
        title: const Text('Error'),
        content: Text(e.toString()),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
        ],
      ),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
