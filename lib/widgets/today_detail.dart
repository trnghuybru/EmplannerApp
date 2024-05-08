import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:emplanner/providers/dashboard_provider.dart';

class TodayDetail extends ConsumerWidget {
  const TodayDetail({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(dashboardDetailProvider);

    return Container(
      height: 140,
      margin: const EdgeInsets.only(left: 5),
      child: Row(
        children: [
          Column(
            children: [
              Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 120, 236, 251),
                        Color.fromARGB(255, 0, 202, 231)
                      ], // Replace with your desired colors
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(14.0),
                      topRight: Radius.circular(6.5),
                      bottomLeft: Radius.circular(6.5),
                      bottomRight: Radius.circular(6.5),
                    ),
                  ),
                  width: 156,
                  height: 45.5,
                  child: Center(
                    child: Text(
                      DateFormat('E, MMM d').format(DateTime.now()),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )),
              const SizedBox(height: 9),
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 159, 251, 228),
                      Color.fromARGB(255, 0, 223, 204)
                    ], // Replace with your desired colors
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(6.5),
                    topRight: Radius.circular(6.5),
                    bottomLeft: Radius.circular(14),
                    bottomRight: Radius.circular(6.5),
                  ),
                ),
                width: 156,
                height: 85.5,
                child: detail.when(
                    data: (detail) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            detail['completedTask'].toString(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            'Completed',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      );
                    },
                    error: (error, stackTrace) => Text('Error: $error'),
                    loading: () {
                      return const Center(child: CircularProgressIndicator());
                    }),
              ),
            ],
          ),
          const SizedBox(width: 9),
          Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 255, 225, 120),
                      Color.fromARGB(255, 255, 184, 0)
                    ], // Replace with your desired colors
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(6.5),
                    topRight: Radius.circular(14),
                    bottomLeft: Radius.circular(6.5),
                    bottomRight: Radius.circular(6.5),
                  ),
                ),
                width: 156,
                height: 85.5,
                child: detail.when(
                    data: (detail) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            detail['incompletedTask'].toString(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            'Incompleted',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      );
                    },
                    error: (error, stackTrace) => Text('Error: $error'),
                    loading: () {
                      return const Center(child: CircularProgressIndicator());
                    }),
              ),
              const SizedBox(height: 9),
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 255, 193, 179),
                      Color.fromARGB(255, 254, 138, 126)
                    ], // Replace with your desired colors
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(6.5),
                    topRight: Radius.circular(6.5),
                    bottomLeft: Radius.circular(6.5),
                    bottomRight: Radius.circular(14),
                  ),
                ),
                width: 156,
                height: 45.5,
                child: detail.when(
                    data: (detail) {
                      return Center(
                        child: Text(
                          detail['cumulativeTime'].toString(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                    error: (error, stackTrace) => Text('Error: $error'),
                    loading: () {
                      return const Center(child: CircularProgressIndicator());
                    }),
              ),
            ],
          ),
        ],
      ),
    );
  
  }
}
