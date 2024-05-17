import 'package:emplanner/services/dashboard_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dashboardProvider = Provider((ref) => DashboardServices());

final dashboardDataProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  return ref.watch(dashboardProvider).getClassExam();
});

final dashboardDetailProvider =
    FutureProvider<Map<String, dynamic>>((ref) async {
  return ref.watch(dashboardProvider).getTodayDetail();
});
