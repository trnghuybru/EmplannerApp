import 'package:emplanner/providers/courses_provider.dart';
import 'package:emplanner/providers/schedule_provider.dart';
import 'package:emplanner/widgets/course_item.dart';
import 'package:emplanner/widgets/new_course_dialog.dart';
import 'package:emplanner/widgets/semester_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class SchedulesScreen extends ConsumerWidget {
  const SchedulesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final semesters = ref.watch(semesterFutureProvider);
    final courses = ref.watch(coursesFutureProvider);

    final dateFormat = DateFormat.yMd();
    final currentDate = DateTime.now();

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Semesters',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                ),
                TextButton(
                  onPressed: () {
                    // Handle See All action
                  },
                  child: Text(
                    'See All',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 61, 143, 239)),
                  ),
                ),
              ],
            ),
          ),
          semesters.when(
            data: (semesters) {
              return SizedBox(
                height: 300,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: semesters.length,
                    itemBuilder: (context, index) {
                      return SemesterCard(
                        semesterName: semesters[index].name,
                        dateRange:
                            '${dateFormat.format(semesters[index].startDate)} - ${dateFormat.format(semesters[index].endDate)}',
                        daysLeft: semesters[index]
                            .endDate
                            .difference(currentDate)
                            .inDays,
                        onTap: () {},
                      );
                    }),
              );
            },
            error: (e, r) => throw Exception(),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Courses',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                ),
                TextButton(
                  onPressed: () {
                    // Handle See All action
                  },
                  child: Text(
                    'Filter',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 61, 143, 239)),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: courses.when(
              data: (courses) {
                return ListView.builder(
                    shrinkWrap: true, // Add this line
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      return CourseItem(
                        courseName: courses[index].name,
                        dateRange:
                            '${dateFormat.format(courses[index].startDate!)} - ${dateFormat.format(courses[index].endDate!)}',
                        dayLeft: courses[index]
                            .endDate!
                            .difference(currentDate)
                            .inDays,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return NewSubjectDialog(
                                course: courses[
                                    index], // Truyền Course vào màn hình chỉnh sửa
                              );
                            },
                          );
                        },
                      );
                    });
              },
              error: (e, r) => throw Exception(),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
