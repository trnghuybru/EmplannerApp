import 'package:flutter/material.dart';

class SemesterCard extends StatelessWidget {
  final String semesterName;
  final String dateRange;
  final int daysLeft;
  final VoidCallback onTap;

  const SemesterCard({
    Key? key,
    required this.semesterName,
    required this.dateRange,
    required this.daysLeft,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: 220,
        height: 260,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 242, 243, 255),
          borderRadius: BorderRadius.circular(14.0),
        ),
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 150,
              width: 220,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.asset(
                  'assets/images/EMPLANNER.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              semesterName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              dateRange,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
            const Spacer(),
            Row(
              children: [
                const Icon(
                  Icons.access_time, // Use the appropriate icon
                  color: Colors.blue,
                  size: 13, // Match the icon color
                ),
                const SizedBox(width: 5),
                Text(
                  daysLeft < 0 ? 'Ended Semester' : '$daysLeft days left',
                  style: const TextStyle(
                    color: Colors.blue, // Match the text color
                    fontSize: 13, // Adjust the font size as needed
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
