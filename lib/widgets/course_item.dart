import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CourseItem extends ConsumerWidget {
  const CourseItem({
    super.key,
    required this.courseName,
    required this.dateRange,
    required this.dayLeft,
  });
  final String courseName;
  final String dateRange;
  final int dayLeft;

  @override
  Widget build(BuildContext context, ref) {
    return Container(
      height: 120,
      width: 350,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 242, 243, 255),
        borderRadius: BorderRadius.circular(14.0),
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                height: 40,
                width: 40,
                child: ClipRRect(
                  child: Image.asset(
                    'assets/images/logo_1.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    courseName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    dateRange,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                dayLeft <= 0 ? 'Ended Course' : 'In-progress',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          const Spacer(),
          const Text(
            '8/8 tasks was done',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          Container(
            width: double.infinity,
            height: 7,
            color: Colors.amber,
          )
        ],
      ),
    );
  }
}
