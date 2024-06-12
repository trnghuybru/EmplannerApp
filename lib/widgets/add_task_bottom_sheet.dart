import 'package:emplanner/models/course.dart';
import 'package:emplanner/models/new_task.dart';
import 'package:emplanner/providers/courses_provider.dart';
import 'package:emplanner/providers/dashboard_provider.dart';
import 'package:emplanner/providers/tasks_provider.dart';
import 'package:emplanner/widgets/buttons/cancel_button.dart';
import 'package:emplanner/widgets/buttons/secondary_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:emplanner/services/task_service.dart';

class NewTaskBottomSheet extends ConsumerStatefulWidget {
  const NewTaskBottomSheet({super.key, required this.courses});
  final List<Course> courses;

  @override
  ConsumerState<NewTaskBottomSheet> createState() => _NewTaskBottomSheetState();
}

class _NewTaskBottomSheetState extends ConsumerState<NewTaskBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _description = TextEditingController();
  late Course _selectedCourse;
  String _selectedType = 'Assignment';
  DateTime? _selectedDate;

  Future<void> saveTask(NewTask task) async {
    if (!mounted) return; // Check if the widget is still mounted
    await TaskServices.saveTask(task);
    if (!mounted) return; // Check again after the asynchronous operation
    ref.refresh(dashboardDetailProvider);
    await ref.read(tasksStateNotifierProvider.notifier).fetchTasks();
  }

  void submit() async {
    final newTask = NewTask(
      courseId: _selectedCourse.id,
      name: _titleController.text,
      startDate: DateTime.now(),
      endDate: _selectedDate!,
      description: _description.text,
      type: _selectedType,
    );
    await saveTask(newTask);
  }

  @override
  void initState() {
    super.initState();
    _selectedCourse = widget.courses[0];
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return LayoutBuilder(builder: (ctx, constrains) {
      final width = constrains.maxWidth;

      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 30, 20, keyboardSpace + 16),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: SizedBox(
                        height: 18,
                        child: Image.asset('assets/images/logo.png')),
                  ),
                  Text(
                    'Course',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: const Color.fromARGB(255, 117, 117, 117)),
                  ),
                  DropdownButtonFormField(
                    value: _selectedCourse,
                    items: widget.courses.map((Course course) {
                      return DropdownMenuItem<Course>(
                        value: course,
                        child: Text(course.name),
                      );
                    }).toList(),
                    onChanged: (Course? newValue) {
                      setState(() {
                        _selectedCourse = newValue!;
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200], // Background color
                    ),
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  ),
                  Text(
                    'Title',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: const Color.fromARGB(255, 117, 117, 117)),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                    controller: _titleController,
                    validator: (value) {},
                  ),
                  Text(
                    'Due date',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: const Color.fromARGB(255, 117, 117, 117)),
                  ),
                  TextFormField(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(DateTime.now().year,
                            DateTime.now().month, DateTime.now().day + 30),
                      );
                      if (picked != null && picked != _selectedDate) {
                        setState(() {
                          _selectedDate = picked;
                        });
                      }
                    },
                    controller: TextEditingController(
                        text: _selectedDate != null
                            ? DateFormat.yMd().format(_selectedDate!)
                            : ''),
                    decoration: InputDecoration(
                        hintText: 'Select Date',
                        prefixIcon: const Icon(Icons.calendar_month_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: Colors.grey[200],
                        filled: true,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 12)),
                  ),
                  Text(
                    'Type',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: const Color.fromARGB(255, 117, 117, 117)),
                  ),
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
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedType = newValue;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        borderSide: BorderSide.none, // Color of the border
                      ),
                      filled: true,
                      fillColor: Colors.grey[200], // Background color
                    ),
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  ),
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: const Color.fromARGB(255, 117, 117, 117)),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                    maxLines: null,
                    controller: _description,
                  ),
                  Row(
                    children: [
                      const CancelButton(),
                      SecondaryButton(
                        title: const Text('Add Task'),
                        icon: Icons.add_rounded,
                        onPressed: () {
                          submit();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Task added successfully!'),
                              duration: Duration(seconds: 2),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
