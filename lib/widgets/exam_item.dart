import 'package:emplanner/models/exam.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExamItem extends StatelessWidget {
  final Exam exam;

  const ExamItem({Key? key, required this.exam}) : super(key: key);

  Color getStatusColor() {
    DateTime today = DateTime.now();
    if (exam.startDate.isAfter(today) ||
        exam.startDate.isAtSameMomentAs(today)) {
      return Colors.blue; // Pending status color
    } else {
      return Colors.green; // Completed status color
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    Duration remainingTime = exam.startDate.difference(today);
    String formattedDate = DateFormat('MM/dd').format(exam.startDate);
    String daysLeft = remainingTime.inDays.toString();
    String daysLeftString = daysLeft == '1' ? '1 day' : '$daysLeft days';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      height: 112,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 242, 243, 255),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 18,
            decoration: BoxDecoration(
              color: getStatusColor(),
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
                            exam.name,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            exam.course!.name,
                            style: const TextStyle(
                              color: Colors.brown,
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
                    color: Colors.black12,
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
                              ? getStatusColor()
                              : remainingTime.inDays < 0
                                  ? Colors.red
                                  : Colors.grey[600],
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
