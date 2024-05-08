import 'package:carousel_slider/carousel_slider.dart';
import 'package:emplanner/models/class_dashboard.dart';
import 'package:emplanner/models/exam_dashboard.dart';
import 'package:emplanner/providers/dashboard_provider.dart';
import 'package:emplanner/widgets/banner.dart';
import 'package:emplanner/widgets/box_chart.dart';
import 'package:emplanner/widgets/class_dashboard.dart';
import 'package:emplanner/widgets/today_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(dashboardDataProvider);
    return data.when(
        data: (data) {
          final todayClasses = data['today']['class'] as List<ClassDashboard>;
          final todayExams = data['today']['exam'] as List<ExamDashboard>;
          final tomorrowClasses =
              data['tomorrow']['class'] as List<ClassDashboard>;
          final tomorrowExams = data['tomorrow']['exam'] as List<ExamDashboard>;
          return Container(
            width: double.infinity,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: CarouselSlider(
                    items: const [
                      DashboardBanner(),
                      BoxTaskChart(),
                      TodayDetail(),
                    ],
                    options: CarouselOptions(
                      height: 140,
                      enableInfiniteScroll: false,
                      initialPage: 1,
                      autoPlay: false,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Text(
                    'Classes - Exam Today',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: SingleChildScrollView(
                    child: SizedBox(
                      height: 220,
                      width: 350,
                      child: ListView.builder(
                        itemCount: todayClasses.length + todayExams.length,
                        itemBuilder: (context, index) {
                          if (index < todayClasses.length) {
                            final item = todayClasses[index];
                            return ClassExamListItem(classItem: item);
                          } else {
                            final item =
                                todayExams[index - todayClasses.length];
                            return ClassExamListItem(examListItem: item);
                          }
                        },
                        shrinkWrap: true,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                // Tomorrow's classes and exams
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Text(
                    'Tomorow',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: SingleChildScrollView(
                    child: SizedBox(
                      height: 220,
                      width: 350,
                      child: ListView.builder(
                        itemCount:
                            tomorrowClasses.length + tomorrowExams.length,
                        itemBuilder: (context, index) {
                          if (index < tomorrowClasses.length) {
                            final item = tomorrowClasses[index];
                            return ClassExamListItem(classItem: item);
                          } else {
                            final item =
                                tomorrowExams[index - tomorrowClasses.length];
                            return ClassExamListItem(examListItem: item);
                          }
                        },
                        shrinkWrap: true,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        error: (error, StackTrace) => Text('Error: $error'),
        loading: () => const Center(child: CircularProgressIndicator()));
  }
}
