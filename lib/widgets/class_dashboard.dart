import 'package:emplanner/models/class_dashboard.dart';
import 'package:emplanner/models/exam_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ClassExamListItem extends StatelessWidget {
  const ClassExamListItem({super.key, this.classItem, this.examListItem});
  final ClassDashboard? classItem;
  final ExamDashboard? examListItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
              color: const Color.fromARGB(66, 149, 149, 149), width: 1.3),
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          leading: SizedBox(
            height: 40,
            width: 40,
            child: Image.asset(
              'assets/images/leading_icon.png',
              fit: BoxFit.fill,
            ),
          ),
          title: Text(
            classItem == null ? 'Exam' : 'Class',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                classItem == null
                    ? examListItem!.courseName
                    : classItem!.courseName,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(classItem == null ? examListItem!.room : classItem!.room),
            ],
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 248, 232),
              borderRadius: BorderRadius.circular(5.5),
            ),
            child: Text(
              _formatTime(classItem == null
                  ? examListItem!.startTime
                  : classItem!.startTime),
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(String time) {
    // Parse the time string to DateTime
    DateTime parsedTime = DateTime.parse('2022-01-01 ' + time);
    // Format the DateTime to 12-hour format
    String formattedTime = DateFormat('h:mm a').format(parsedTime);
    return formattedTime;
  }
}
