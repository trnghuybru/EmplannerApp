import 'package:emplanner/providers/dashboard_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BoxTaskChart extends ConsumerWidget {
  const BoxTaskChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(dashboardDetailProvider);

    int? percent = detail.when(
      data: (detail) {
        return detail['completedTask'] != 0 || detail['incompletedTask'] != 0
            ? ((detail['completedTask'] /
                        (detail['completedTask'] + detail['incompletedTask'])) *
                    100)
                .round()
            : 100;
      },
      error: (error, stackTrace) => null,
      loading: () => null,
    );

    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      height: 140,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 255, 184, 0),
            Color.fromARGB(255, 255, 225, 120)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.all(Radius.circular(14)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Your today's task almost done!",
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 247, 225),
                    shadowColor: const Color.fromARGB(0, 255, 247, 225),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    'View Task',
                    style: TextStyle(
                        color: Color.fromARGB(255, 250, 187, 24),
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 30,
          ),
          SizedBox(
            width: 100,
            height: 100,
            child: Stack(
              children: [
                TweenAnimationBuilder<double>(
                  duration:
                      const Duration(milliseconds: 500), // Animation duration
                  tween: Tween<double>(
                      begin: 0,
                      end: percent == null
                          ? 0
                          : percent.toDouble()), // Animation range
                  builder: (context, value, child) {
                    return PieChart(
                      PieChartData(
                        startDegreeOffset: -90,
                        sectionsSpace: 0,
                        sections: [
                          PieChartSectionData(
                            value: value,
                            color: const Color.fromARGB(255, 248, 255, 251),
                            radius: 18,
                            showTitle: false,
                          ),
                          PieChartSectionData(
                            value: 100 - value,
                            color: const Color.fromARGB(80, 255, 255, 255),
                            radius: 18,
                            showTitle: false,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Positioned.fill(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 65,
                        width: 65,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(0, 255, 255, 255),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                            child: detail.when(
                          data: (detail) {
                            return Text(
                              '$percent%',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            );
                          },
                          error: (error, stackTrace) => Text('Error: $error'),
                          loading: () => const CircularProgressIndicator(),
                        )),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
