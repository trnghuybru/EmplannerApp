import 'package:emplanner/models/course.dart';
import 'package:emplanner/models/new_task.dart';
import 'package:emplanner/models/task.dart';
import 'package:emplanner/providers/dashboard_provider.dart';
import 'package:emplanner/providers/tasks_provider.dart';
import 'package:emplanner/services/task_service.dart';
import 'package:emplanner/widgets/buttons/secondary_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class TaskDialog extends ConsumerStatefulWidget {
  const TaskDialog({super.key, required this.task, required this.courses});
  final List<Course> courses;
  final Task task;

  @override
  ConsumerState<TaskDialog> createState() => _TaskDialogState();
}

class _TaskDialogState extends ConsumerState<TaskDialog> {
  final _titleController = TextEditingController();
  final _description = TextEditingController();
  late DateTime _selectedDate;
  late Course _selectedCourse;
  bool isEdit = false;
  late String _selectedType;

  @override
  void initState() {
    super.initState();
    _selectedCourse = widget.courses
        .firstWhere((course) => course.id == widget.task.courseId);
    _selectedType = widget.task.type!;
    _selectedDate = widget.task.endDate!;
  }

  void _editTask(bool isToggleDone) async {
    if (isToggleDone) {
      NewTask task = NewTask(
        courseId: _selectedCourse.id,
        name: widget.task.taskName,
        startDate: DateTime.now(),
        endDate: _selectedDate,
        type: _selectedType,
        status: widget.task.status == 0 ? 1 : 0,
        description: widget.task.description,
      );
      TaskServices.updateTask(widget.task.id.toString(), task);
      ref.refresh(dashboardDetailProvider);
      await ref.read(tasksStateNotifierProvider.notifier).fetchTasks();
    } else {
      NewTask task = NewTask(
        courseId: _selectedCourse.id,
        name: _titleController.text,
        endDate: _selectedDate,
        type: _selectedType,
      );
      TaskServices.updateTask(widget.task.id.toString(), task);
    }

    // Cap nhat lai giao dien DashBoard
    //todo
    //
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: keyboardHeight),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 60,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 251, 204, 84),
                    Color.fromARGB(255, 255, 184, 0)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 22.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    10,
                    (index) => const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                      child: CircleAvatar(
                        radius: 6,
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Form(
                child: Column(
                  children: [
                    DropdownButtonFormField(
                      value: _selectedCourse,
                      items: widget.courses.map((Course course) {
                        return DropdownMenuItem<Course>(
                          value: course,
                          child: Text(course.name),
                        );
                      }).toList(),
                      onChanged: isEdit
                          ? (Course? newValue) {
                              setState(() {
                                _selectedCourse = newValue!;
                              });
                            }
                          : null,
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                          labelText: 'Course'
                          // Background color
                          ),
                      icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    ),
                    const SizedBox(height: 12.0),
                    TextFormField(
                      readOnly: !isEdit,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                        labelText: 'Title',
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                      controller: isEdit ? _titleController : null,
                      initialValue: widget.task.taskName,
                      validator: (value) {},
                    ),
                    const SizedBox(height: 12.0),
                    TextFormField(
                      readOnly: !isEdit,
                      onTap: () {},
                      decoration: InputDecoration(
                          suffixIcon: const Icon(Icons.calendar_month_rounded),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                          fillColor: Colors.grey[200],
                          filled: true,
                          labelText: 'Due date',
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16.0)),
                      initialValue:
                          DateFormat('MM-dd-yyyy').format(widget.task.endDate!),
                    ),
                    const SizedBox(height: 12.0),
                    DropdownButtonFormField(
                      value: _selectedType,
                      items: const [
                        DropdownMenuItem(
                          value: 'Assignment',
                          child: Text('Assignment'),
                        ),
                        DropdownMenuItem(
                          value: 'Reminder',
                          child: Text('Reminder'),
                        ),
                        DropdownMenuItem(
                          value: 'Revision',
                          child: Text('Revision'),
                        ),
                      ],
                      onChanged: isEdit
                          ? (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _selectedType = newValue;
                                });
                              }
                            }
                          : null,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          borderSide: BorderSide.none, // Color of the border
                        ),
                        labelText: 'Type',
                        filled: true,
                        fillColor: Colors.grey[200], // Background color
                      ),
                      icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    ),
                    const SizedBox(height: 12.0),
                    TextFormField(
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                        labelText: 'Description',
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                      readOnly: !isEdit,
                      maxLines: null,
                      initialValue: widget.task.description,
                      controller: isEdit ? _description : null,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SecondaryButton(
                  icon: Icons.edit_rounded,
                  title: const Text('Edit'),
                  onPressed: () {},
                ),
                SecondaryButton(
                  icon: widget.task.status == 1
                      ? Icons.done_outline_rounded
                      : Icons.check_rounded,
                  title: Text(widget.task.status == 1 ? 'Undone' : 'Done'),
                  onPressed: () {
                    _editTask(true);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(widget.task.status == 1
                            ? 'Marked as undone'
                            : 'Marked as done'),
                        duration: const Duration(seconds: 2),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            const SizedBox(height: 20.0)
          ],
        ),
      ),
    );
  }
}
