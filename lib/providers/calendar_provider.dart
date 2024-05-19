import 'package:emplanner/models/calendar_class.dart';
import 'package:emplanner/services/calendar_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final calendarProvider = Provider((ref) => CalendarService());

final calendarDataProvider = FutureProvider<List<CalendarClass>>((ref) async {
  return ref.watch(calendarProvider).fetchClass();
});
