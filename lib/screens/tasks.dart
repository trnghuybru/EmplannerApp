import 'dart:async';

import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:emplanner/providers/tasks_provider.dart';
import 'package:emplanner/screens/tabs.dart';
import 'package:emplanner/widgets/add_task_bottom_sheet.dart';
import 'package:emplanner/widgets/buttons/secondary_buttons.dart';
import 'package:emplanner/widgets/task_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class TasksScreen extends ConsumerWidget {
  const TasksScreen({super.key});

  void _openAddTaskOverLay(BuildContext context) {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (context) => const NewTaskBottomSheet(),
      constraints: const BoxConstraints(maxWidth: double.infinity),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(taskFutureProvider);

    //need to change to ListView
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
                onPressed: () {
                  _openAddTaskOverLay(context);
                },
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
            initialSelectedDate: DateTime.now(),
            selectionColor: const Color.fromARGB(255, 250, 187, 24),
            selectedTextColor: Colors.white,
            dateTextStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color.fromARGB(255, 73, 73, 73),
            ),
          ),
        ),
        data.when(
            data: (data) {
              return Expanded(
                child: SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) =>
                        TaskItem(task: data[index]),
                  ),
                ),
              );
            },
            error: (e, r) => Text(e.toString()),
            loading: () => const CircularProgressIndicator())
      ],
    );
  }
}
