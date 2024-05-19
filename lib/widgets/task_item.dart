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
    DateTime endDate =
        DateTime(task.endDate!.year, task.endDate!.month, task.endDate!.day);
    DateTime today = DateTime(now.year, now.month, now.day);
    Duration remainingTime = endDate.difference(today);
    String formattedDate = DateFormat('MM/dd').format(endDate);
    String daysLeft = remainingTime.inDays.toString();
    String daysLeftString = daysLeft == '1' ? '1 day' : '$daysLeft days';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      height: 112,
      decoration: BoxDecoration(
        color: task.status == 0
            ? const Color.fromARGB(255, 242, 243, 255)
            : Colors.grey[300],
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        children: [
          Container(
            width: 18,
            decoration: BoxDecoration(
              color: task.status == 0
                  ? hexToColor(task.colorCode!)
                  : Colors.grey[400],
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
                            style: TextStyle(
                              color: task.status == 0
                                  ? const Color.fromARGB(255, 0, 0, 0)
                                  : const Color.fromARGB(255, 113, 113, 113),
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
                        remainingTime.inDays == 0
                            ? '$formattedDate |  Today'
                            : remainingTime.inDays < 0
                                ? '$formattedDate |  Overdue'
                                : '$formattedDate |  $daysLeftString left',
                        style: TextStyle(
                          color: remainingTime.inDays == 0
                              ? task.status == 1
                                  ? Colors.grey
                                  : Colors.green
                              : remainingTime.inDays < 0
                                  ? Colors.red // Màu đỏ cho "Overdue"
                                  : const Color.fromARGB(255, 113, 113,
                                      113), // Màu mặc định cho trường hợp khác
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
