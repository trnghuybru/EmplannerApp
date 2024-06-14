import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:emplanner/widgets/buttons/secondary_buttons.dart';
import 'package:emplanner/widgets/task_dialog.dart';
import 'package:emplanner/widgets/task_item.dart';
import 'package:emplanner/models/course.dart';
import 'package:emplanner/models/new_task.dart';
import 'package:emplanner/providers/courses_provider.dart';
import 'package:emplanner/providers/dashboard_provider.dart';
import 'package:emplanner/providers/tasks_provider.dart';
import 'package:emplanner/services/task_service.dart';
import 'package:emplanner/widgets/add_task_bottom_sheet.dart';

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
    final isOverdueMode = ref.watch(overdueModeProvider);

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
            child: filteredTasks.isEmpty
                ? const Center(child: Text("No tasks were found."))
                : ListView.builder(
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: courses.when(
                            data: (courses) {
                              return () {
                                _showPopupDialog(
                                    context,
                                    filteredTasks[index].id.toString(),
                                    courses);
                              };
                            },
                            error: (e, r) {
                              return () {};
                            },
                            loading: () => () {}),
                        child: Dismissible(
                          key: UniqueKey(),
                          direction: DismissDirection.horizontal,
                          background: Container(
                            color: Colors.green,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 20),
                            child: Row(
                              children: [
                                filteredTasks[index].status == 0
                                    ? const Icon(Icons.check,
                                        color: Colors.white)
                                    : const Icon(Icons.unpublished_outlined,
                                        color: Colors.white),
                                const SizedBox(width: 10),
                                Text(
                                  filteredTasks[index].status == 0
                                      ? 'Done'
                                      : 'Undone',
                                  style: const TextStyle(
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
                                    title: Text(filteredTasks[index].status == 0
                                        ? 'Done Task'
                                        : 'Undone Task'),
                                    content: Text(filteredTasks[index].status ==
                                            0
                                        ? 'Are you sure you want to mark this task as done?'
                                        : 'Are you sure you want to mark this task as undone'),
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
                                        child: Text(
                                            filteredTasks[index].status == 0
                                                ? 'Done'
                                                : 'Undone'),
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
                              NewTask task = NewTask(
                                courseId: filteredTasks[index].courseId,
                                name: filteredTasks[index].taskName!,
                                startDate: DateTime.now(),
                                endDate: filteredTasks[index].endDate!,
                                type: filteredTasks[index].type!,
                                status:
                                    filteredTasks[index].status == 0 ? 1 : 0,
                                description: filteredTasks[index].description,
                              );
                              TaskServices.updateTask(
                                  filteredTasks[index].id.toString(), task);
                              await ref
                                  .read(tasksStateNotifierProvider.notifier)
                                  .fetchTasks();
                              ref.refresh(dashboardDetailProvider);
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
        ref.read(overdueModeProvider.notifier).toggle();
      },
    );
  }
}
