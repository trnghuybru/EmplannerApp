import 'package:emplanner/providers/calendar_provider.dart';
import 'package:emplanner/providers/courses_provider.dart';
import 'package:emplanner/providers/dashboard_provider.dart';
import 'package:emplanner/providers/tasks_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:emplanner/models/course.dart';
import 'package:emplanner/models/semester.dart';
import 'package:emplanner/providers/schedule_provider.dart';
import 'package:emplanner/services/schedule_service.dart';

class NewSubjectDialog extends ConsumerStatefulWidget {
  final Course? course;

  const NewSubjectDialog({Key? key, this.course}) : super(key: key);

  @override
  ConsumerState<NewSubjectDialog> createState() => _NewSubjectDialogState();
}

class _NewSubjectDialogState extends ConsumerState<NewSubjectDialog> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _teacher;
  String? _selectedSchoolYear;
  String? _term;
  DateTime? _startDate;
  DateTime? _endDate;
  Color _selectedColor = Colors.white;

  List<Semester> _filteredSemesters = [];

  @override
  void initState() {
    super.initState();
    if (widget.course != null) {
      _name = widget.course!.name;
      _teacher = widget.course!.teacher;
      _selectedSchoolYear = widget.course!.semesterId.toString();
      _term = widget.course!.semesterId.toString();
      _startDate = widget.course!.startDate;
      _endDate = widget.course!.endDate;
      _selectedColor = Color(int.parse(
          widget.course!.colorCode!.replaceFirst('#', 'ff'),
          radix: 16));
    }
  }

  Future<void> _pickDate(
      BuildContext context, ValueChanged<DateTime?> onDateSelected) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      onDateSelected(picked);
    }
  }

  void _filterSemesters(String schoolYearId, List<Semester> semesters) {
    setState(() {
      _filteredSemesters = semesters
          .where((semester) => semester.schoolYearId.toString() == schoolYearId)
          .toList();
      if (_filteredSemesters.isNotEmpty &&
          !_filteredSemesters
              .any((semester) => semester.id.toString() == _term)) {
        _term = _filteredSemesters.first.id.toString();
      } else if (_filteredSemesters.isEmpty) {
        _term = null;
      }
    });
  }

  Future<bool> _saveCourse() async {
    Course course = Course(
      id: widget.course?.id,
      semesterId: int.tryParse(_term!),
      name: _name!,
      teacher: _teacher!,
      startDate: _startDate!,
      endDate: _endDate!,
      colorCode: _selectedColorToHex(),
    );

    if (widget.course == null) {
      await ScheduleService.saveCourse(course);
    } else {
      await ScheduleService.updateCourse(course);
      ref.read(calendarStateNotifierProvider.notifier).fetchCalendarClasses();
      ref.read(tasksStateNotifierProvider.notifier).fetchTasks();
    }
    return true;
  }

  String _selectedColorToHex() {
    return '#${_selectedColor.value.toRadixString(16).substring(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final semesterProvider = ref.watch(semesterFutureProvider);
    final schoolYearsProvider = ref.watch(yearsFutureProvider);

    return schoolYearsProvider.when(
      data: (schoolYears) {
        return AlertDialog(
          title: Text(widget.course == null ? 'New Subject' : 'Edit Subject'),
          content: SingleChildScrollView(
            child: semesterProvider.when(
              data: (semesters) {
                if (_selectedSchoolYear != null) {
                  _filterSemesters(_selectedSchoolYear!, semesters);
                }

                return Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Name'),
                        initialValue: _name,
                        onChanged: (value) {
                          _name = value;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Teacher'),
                        initialValue: _teacher,
                        onChanged: (value) {
                          _teacher = value;
                        },
                      ),
                      DropdownButtonFormField<String>(
                        decoration:
                            const InputDecoration(labelText: 'School Year'),
                        items: schoolYears.map((year) {
                          return DropdownMenuItem(
                            value: year.id.toString(),
                            child: Text(
                                '${year.startDate.toIso8601String().split('T')[0]} : ${year.endDate.toIso8601String().split('T')[0]}'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedSchoolYear = value;
                            _filterSemesters(value!, semesters);
                          });
                        },
                        value: schoolYears.any((year) =>
                                year.id.toString() == _selectedSchoolYear)
                            ? _selectedSchoolYear
                            : null,
                      ),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: 'Term'),
                        items: _filteredSemesters.map((term) {
                          return DropdownMenuItem(
                            value: term.id.toString(),
                            child: Text(term.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _term = value;
                          });
                        },
                        value: _filteredSemesters.any(
                                (semester) => semester.id.toString() == _term)
                            ? _term
                            : null,
                      ),
                      ListTile(
                        title: const Text('Start date'),
                        subtitle: Text(
                          _startDate == null
                              ? 'Select Start Date'
                              : DateFormat('MM/dd/yyyy').format(_startDate!),
                        ),
                        onTap: () {
                          _pickDate(context, (date) {
                            setState(() {
                              _startDate = date;
                            });
                          });
                        },
                      ),
                      ListTile(
                        title: const Text('End date'),
                        subtitle: Text(
                          _endDate == null
                              ? 'Select End Date'
                              : DateFormat('MM/dd/yyyy').format(_endDate!),
                        ),
                        onTap: () {
                          _pickDate(context, (date) {
                            setState(() {
                              _endDate = date;
                            });
                          });
                        },
                      ),
                      ListTile(
                        title: const Text('Color'),
                        subtitle: Container(
                          width: 24,
                          height: 24,
                          color: _selectedColor,
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Pick a color'),
                                content: SingleChildScrollView(
                                  child: ColorPicker(
                                    pickerColor: _selectedColor,
                                    onColorChanged: (Color color) {
                                      setState(() {
                                        _selectedColor = color;
                                      });
                                    },
                                    pickerAreaHeightPercent: 0.8,
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Select'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: Text(
                          'What Are Subjects?\nSubjects are also known as courses and enable you to group all of your classes, tasks, and exams for that course.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                );
              },
              error: (e, r) => throw Exception(e),
              loading: () => const Center(child: CircularProgressIndicator()),
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
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _saveCourse();
                  ref.read(coursesStateNotifierProvider.notifier).fetchTasks();
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(widget.course == null
                          ? 'Created New Course!'
                          : 'Updated Course!'),
                      duration: const Duration(seconds: 2),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
      error: (e, r) => throw Exception(e),
      loading: () => const CircularProgressIndicator(),
    );
  }
}
