import 'package:emplanner/models/calendar_class.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ClassDialog extends StatefulWidget {
  const ClassDialog({
    super.key,
    required this.caclass,
  });
  final CalendarClass caclass;

  @override
  State<ClassDialog> createState() => _ClassDialogState();
}

class _ClassDialogState extends State<ClassDialog> {
  final _courseController = TextEditingController();
  final _roomController = TextEditingController();
  final _teacherController = TextEditingController();
  DateTime _selectedDate = DateTime(2024, 1, 15);
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  Map<String, bool> _daysOfWeek = {
    "Mon": false,
    "Tue": false,
    "Wed": false,
    "Thu": false,
    "Fri": false,
    "Sat": false,
    "Sun": false,
  };

  bool isEdit = false;

  String? dayOfWeek;

  @override
  void initState() {
    super.initState();
    dayOfWeek = widget.caclass.dayOfWeek;
    if (dayOfWeek != null) {
      _daysOfWeek = parseDaysOfWeek(dayOfWeek!);
    }
    _courseController.text = widget.caclass.courseName;
    _roomController.text = widget.caclass.room;
    _teacherController.text = widget.caclass.teacher;
    _selectedDate = DateTime.parse(widget.caclass.date);

    _startTime = parseTime(widget.caclass.startTime);
    _endTime = parseTime(widget.caclass.endTime);
  }

  Map<String, bool> parseDaysOfWeek(String dayOfWeekString) {
    if (dayOfWeekString.isEmpty) {
      return _daysOfWeek;
    }
    final List<String> abbreviatedDays = dayOfWeekString.split(',').map((day) {
      return day.substring(0, 3);
    }).toList();
    final Set<String> selectedDays = Set.from(abbreviatedDays);

    final Map<String, bool> parsedDays = Map.from(_daysOfWeek);

    for (final day in parsedDays.keys) {
      parsedDays[day] = selectedDays.contains(day);
    }

    return parsedDays;
  }

  TimeOfDay parseTime(String timeString) {
    final parts = timeString.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _startTime : _endTime,
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final format = DateFormat.jm();
    return format.format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: keyboardHeight),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
          child: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _courseController,
                  decoration: InputDecoration(
                    labelText: 'Course',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
                const SizedBox(height: 12.0),
                TextFormField(
                  controller: _roomController,
                  decoration: InputDecoration(
                    labelText: 'Room',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
                const SizedBox(height: 12.0),
                TextFormField(
                  readOnly: true,
                  onTap: () => _selectDate(context),
                  decoration: InputDecoration(
                    labelText: 'Date',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  controller: TextEditingController(
                    text: DateFormat('yyyy-MM-dd').format(_selectedDate),
                  ),
                ),
                const SizedBox(height: 12.0),
                Wrap(
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
                ),
                const SizedBox(height: 12.0),
                TextField(
                  readOnly: true,
                  onTap: () => _selectTime(context, true),
                  decoration: InputDecoration(
                    labelText: 'Start Time',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  controller: TextEditingController(
                    text: _formatTime(_startTime),
                  ),
                ),
                const SizedBox(height: 12.0),
                TextField(
                  readOnly: true,
                  onTap: () => _selectTime(context, false),
                  decoration: InputDecoration(
                    labelText: 'End Time',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  controller: TextEditingController(
                    text: _formatTime(_endTime),
                  ),
                ),
                const SizedBox(height: 12.0),
                TextField(
                  controller: _teacherController,
                  decoration: InputDecoration(
                    labelText: 'Teacher',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Handle the save action
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Class details saved!'),
                        duration: Duration(seconds: 2),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
