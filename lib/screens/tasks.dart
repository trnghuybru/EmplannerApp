import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:emplanner/models/course.dart';
import 'package:emplanner/models/new_task.dart';
import 'package:emplanner/models/task.dart';
import 'package:emplanner/providers/courses_provider.dart';
import 'package:emplanner/providers/dashboard_provider.dart';
import 'package:emplanner/providers/tasks_provider.dart';
import 'package:emplanner/services/task_service.dart';
import 'package:emplanner/widgets/add_task_bottom_sheet.dart';
import 'package:emplanner/widgets/buttons/secondary_buttons.dart';
import 'package:emplanner/widgets/task_dialog.dart';
import 'package:emplanner/widgets/task_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class TasksScreen extends ConsumerWidget {
  const TasksScreen({super.key});

  void _openAddTaskOverLay(BuildContext context, List<Course> course) {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (context) => NewTaskBottomSheet(courses: course),
      constraints: const BoxConstraints(maxWidth: double.infinity),
    );
  }

  void _deleteTask(String id) async {
    await TaskServices.deleteTask(id);
  }

  void _showPopupDialog(
      BuildContext context, String taskId, List<Course> courses) {
    TaskServices.getTask(taskId).then((task) {
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return TaskDialog(
            task: task,
            courses: courses,
          );
        },
      );
    }).catchError((error) {
      // Handle error if any
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(taskFutureProvider);
    final courses = ref.watch(coursesFutureProvider);
    final selectedDate = ref.watch(selectedDateProvider);
    final filteredTasks = ref.watch(taskFilterProvider);

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
              SecondaryButton(
                icon: Icons.add_rounded,
                title: const Text('Add Task'),
                onPressed: courses.when(
                    data: (course) {
                      return () {
                        _openAddTaskOverLay(context, course);
                      };
                    },
                    error: (e, r) {
                      return () {};
                    },
                    loading: () => () {}),
              ),
            ],
          ),
        ),
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
                  data: (tasks) {
                    ref.read(selectedDateProvider.notifier).state =
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
            child: ListView.builder(
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: courses.when(
                      data: (courses) {
                        return () {
                          _showPopupDialog(context,
                              filteredTasks[index].id.toString(), courses);
                        };
                      },
                      error: (e, r) {
                        return () {};
                      },
                      loading: () => () {}),
                  child: Dismissible(
                    key: ValueKey(filteredTasks[index].id),
                    direction: DismissDirection.horizontal,
                    background: Container(
                      color: Colors.green,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 20),
                      child: const Row(
                        children: [
                          Icon(Icons.check, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            'Complete',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    secondaryBackground: Container(
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
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 10),
                          Icon(Icons.cancel, color: Colors.white),
                        ],
                      ),
                    ),
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.startToEnd) {
                        // Handle the complete action
                        return await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Complete Task'),
                              content: const Text(
                                  'Are you sure you want to mark this task as complete?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Perform complete action here, e.g., update the task status
                                    Navigator.of(context).pop(true);
                                  },
                                  child: const Text('Complete'),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        return await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Delete Task'),
                              content: const Text(
                                  'Are you sure you want to delete this task?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Perform delete action here, e.g., remove the task from the database
                                    Navigator.of(context).pop(true);
                                  },
                                  child: const Text('Delete'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    onDismissed: (direction) async {
                      if (direction == DismissDirection.startToEnd) {
                      } else {
                        _deleteTask(filteredTasks[index].id.toString());
                        ref.refresh(dashboardDetailProvider);
                        await ref
                            .read(tasksStateNotifierProvider.notifier)
                            .fetchTasks();
                      }
                    },
                    child: TaskItem(task: filteredTasks[index]),
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
