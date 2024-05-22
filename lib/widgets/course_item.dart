import 'package:flutter/material.dart';

class CourseItem extends StatelessWidget {
  const CourseItem({super.key});

  @override
  Widget build(BuildContext context) {
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
                  const Text(
                    'semesterName',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'dateRange',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const Text(
                'In-progress',
                style: TextStyle(fontSize: 12, color: Colors.grey),
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
