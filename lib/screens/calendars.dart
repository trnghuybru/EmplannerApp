import 'package:emplanner/providers/calendar_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:emplanner/models/calendar_class.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  bool vertical = false;
  final List<bool> _selectedView = <bool>[true, false, false];
  final CalendarController _controller = CalendarController();

  Future<dynamic> showDetailClass(
      BuildContext context, Appointment appointment) {
    return showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(appointment.subject),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Start Time: ${appointment.startTime}'),
                Text('End Time: ${appointment.endTime}'),
                Text('Description: ${appointment.notes ?? "No description"}')
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final classList = ref.watch(calendarDataProvider);

    if (_selectedView[0]) {
      _controller.view = CalendarView.day;
    } else if (_selectedView[1]) {
      _controller.view = CalendarView.week;
    } else if (_selectedView[2]) {
      _controller.view = CalendarView.month;
    }

    return classList.when(
      data: (classList) {
        List<Appointment> appointments = getAppointments(classList);
        return Column(
          children: [
            ToggleButtons(
              direction: vertical ? Axis.vertical : Axis.horizontal,
              onPressed: (int index) {
                setState(() {
                  for (int i = 0; i < _selectedView.length; i++) {
                    _selectedView[i] = i == index;
                  }
                });
              },
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              selectedColor: const Color.fromARGB(255, 255, 255, 255),
              selectedBorderColor: Colors.black,
              fillColor: const Color.fromARGB(255, 0, 0, 0),
              constraints: const BoxConstraints(
                minHeight: 35.0,
                minWidth: 80.0,
              ),
              isSelected: _selectedView,
              children: [
                Text(
                  'day',
                  style: TextStyle(
                    color: _selectedView[0] ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  'week',
                  style: TextStyle(
                    color: _selectedView[1] ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  'month',
                  style: TextStyle(
                    color: _selectedView[2] ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: SfCalendar(
                view: CalendarView.month,
                controller: _controller,
                cellBorderColor: Colors.grey[300],
                dataSource: MeetingDataSourse(appointments),
                showNavigationArrow: true,
                showDatePickerButton: true,
                headerStyle: const CalendarHeaderStyle(
                  textAlign: TextAlign.center,
                  backgroundColor: Colors.amber,
                  textStyle: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                monthViewSettings: const MonthViewSettings(
                  showAgenda: true,
                  agendaItemHeight: 50,
                  agendaStyle: AgendaStyle(
                    appointmentTextStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  navigationDirection: MonthNavigationDirection.vertical,
                ),
                todayHighlightColor: Colors.amber,
                onTap: (calendarTapDetails) {
                  if (calendarTapDetails.targetElement ==
                      CalendarElement.appointment) {
                    final Appointment appointment =
                        calendarTapDetails.appointments!.first;
                    showDetailClass(context, appointment);
                  }
                },
              ),
            ),
          ],
        );
      },
      error: (e, r) => throw Exception(e),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

Color hexToColor(String code) {
  return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

List<Appointment> getAppointments(List<CalendarClass> classList) {
  List<Appointment> appointments = [];

  for (final cl in classList) {
    DateFormat format = DateFormat("yyyy-MM-dd");
    DateTime parsedDate = format.parse(cl.date);

    DateTime startTime = _combineDateAndTime(parsedDate, cl.startTime);
    DateTime endTime = _combineDateAndTime(parsedDate, cl.endTime);

    appointments.add(Appointment(
      startTime: startTime,
      endTime: endTime,
      subject: cl.courseName,
      location: cl.room,
      notes: cl.id.toString(),
      color: hexToColor(cl.colorCode),
    ));
  }

  return appointments;
}

class MeetingDataSourse extends CalendarDataSource {
  MeetingDataSourse(List<Appointment> soure) {
    appointments = soure;
  }
}

DateTime _combineDateAndTime(DateTime date, String time) {
  List<String> timeParts = time.split(':');
  DateTime dateTime = DateTime(
    date.year,
    date.month,
    date.day,
    int.parse(timeParts[0]),
    int.parse(timeParts[1]),
    int.parse(timeParts[2]),
  );
  return dateTime;
}
