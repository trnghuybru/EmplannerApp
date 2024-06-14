import 'package:emplanner/models/calendar_class.dart';
import 'package:emplanner/services/calendar_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CalendarNotifier extends StateNotifier<List<CalendarClass>> {
  CalendarNotifier() : super([]) {
    fetchCalendarClasses();
  }

  Future<void> fetchCalendarClasses() async {
    try {
      final classes = await CalendarService.fetchClass();
      state = classes;
    } catch (e) {
      throw Exception(e);
    }
  }
}

final calendarStateNotifierProvider =
    StateNotifierProvider<CalendarNotifier, List<CalendarClass>>(
  (ref) => CalendarNotifier(),
);

final classFutureProvider = FutureProvider((ref) async {
  await ref.read(calendarStateNotifierProvider.notifier).fetchCalendarClasses();
  return ref.watch(calendarStateNotifierProvider);
});
