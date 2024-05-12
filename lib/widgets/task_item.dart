import 'package:emplanner/models/task.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskItem extends StatelessWidget {
  const TaskItem({super.key, required this.task});
  final Task task;

  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    Duration remainingTime = task.endDate!.difference(now);
    String formattedDate = DateFormat('MM/dd').format(task.endDate!);
    String daysLeft = remainingTime.inDays.toString();
    String daysLeftString = daysLeft == '1' ? '1 day' : '$daysLeft days';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      height: 112,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 242, 243, 255),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        children: [
          Container(
            width: 18,
            decoration: BoxDecoration(
              color: hexToColor(task.colorCode),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.taskName,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            task.courseName,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 113, 113, 113),
                              fontSize: 12.0,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      const Icon(Icons.more_vert_rounded)
                    ],
                  ),
                  const Divider(
                    color: Color.fromARGB(29, 0, 0, 0),
                    thickness: 1.0,
                    height: 20,
                    indent: 5,
                    endIndent: 20,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.access_time_rounded, size: 15),
                      const SizedBox(width: 5),
                      Text(
                        '$formattedDate $daysLeftString left',
                        style: const TextStyle(
                          color: Color.fromARGB(255, 113, 113, 113),
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
