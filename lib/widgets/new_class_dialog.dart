import 'package:emplanner/models/school_class.dart';
import 'package:emplanner/providers/calendar_provider.dart';
import 'package:emplanner/providers/courses_provider.dart';
import 'package:emplanner/providers/dashboard_provider.dart';
import 'package:emplanner/services/schedule_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class CreateClassDialog extends ConsumerStatefulWidget {
  const CreateClassDialog({super.key});

  @override
  ConsumerState<CreateClassDialog> createState() => _CreateClassDialogState();
}

class _CreateClassDialogState extends ConsumerState<CreateClassDialog> {
  String? _selectedSubject;
  String _room = '';
  bool _isRepeating = false;
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  final Map<String, bool> _daysOfWeek = {
    "Mon": false,
    "Tue": false,
    "Wed": false,
    "Thu": false,
    "Fri": false,
    "Sat": false,
    "Sun": false,
  };

  @override
  Widget build(BuildContext context) {
    final subjects = ref.watch(coursesFutureProvider);

    return subjects.when(
        data: (subjects) {
          return AlertDialog(
            title: const Text('Create New Class'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Subject'),
                    items: subjects.map((subject) {
                      return DropdownMenuItem(
                        value: subject.id.toString(),
                        child: Text(subject.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedSubject = value;
                      });
                    },
                    value: _selectedSubject,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Room'),
                    onChanged: (value) {
                      setState(() {
                        _room = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Repeats'),
                    value: _isRepeating,
                    onChanged: (value) {
                      setState(() {
                        _isRepeating = value;
                      });
                    },
                  ),
                  _isRepeating
                      ? Wrap(
                          spacing: 6.0,
                          children: _daysOfWeek.keys.map((String day) {
                            return FilterChip(
                              label: Text(day),
                              selected: _daysOfWeek[day]!,
                              onSelected: (bool selected) {
                                setState(() {
                                  _daysOfWeek[day] = selected;
                                });
                              },
                            );
                          }).toList(),
                        )
                      : ListTile(
                          title: const Text('Date'),
                          subtitle: Text(_selectedDate == null
                              ? 'Select Date'
                              : DateFormat('MM/dd/yyyy')
                                  .format(_selectedDate!)),
                          onTap: _pickDate,
                        ),
                  ListTile(
                    title: const Text('Start Time'),
                    subtitle: Text(_startTime == null
                        ? 'Select Start Time'
                        : _startTime!.format(context)),
                    onTap: _pickStartTime,
                  ),
                  ListTile(
                    title: const Text('End Time'),
                    subtitle: Text(_endTime == null
                        ? 'Select End Time'
                        : _endTime!.format(context)),
                    onTap: _pickEndTime,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: _saveClass,
                child: const Text('Save'),
              ),
            ],
          );
        },
        error: (e, r) => throw Exception(e),
        loading: () => const CircularProgressIndicator());
  }

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _pickStartTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != _startTime) {
      setState(() {
        _startTime = pickedTime;
      });
    }
  }

  void _pickEndTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != _endTime) {
      setState(() {
        _endTime = pickedTime;
      });
    }
  }

  String _generateDaysOfWeekString() {
    // Map of shortened day names to full names
    final Map<String, String> fullDayNames = {
      "Mon": "Monday",
      "Tue": "Tuesday",
      "Wed": "Wednesday",
      "Thu": "Thursday",
      "Fri": "Friday",
      "Sat": "Saturday",
      "Sun": "Sunday",
    };

    List<String> selectedDays = [];
    _daysOfWeek.forEach((day, isSelected) {
      if (isSelected) {
        selectedDays.add(fullDayNames[day]!);
      }
    });
    return selectedDays.join(',');
  }

  void _saveClass() async {
    // Generate the days of week string
    String daysOfWeekString = _generateDaysOfWeekString();
    print(daysOfWeekString);
    SchoolClass cl = SchoolClass(
      room: _room,
      startTime: _startTime!,
      endTime: _endTime!,
      date: _selectedDate,
      dayOfWeek: daysOfWeekString,
    );
    await ScheduleService.saveClass(cl, _selectedSubject!);
    await ref
        .read(calendarStateNotifierProvider.notifier)
        .fetchCalendarClasses();
    ref.refresh(dashboardDataProvider);
    Navigator.of(context).pop();
  }
}
