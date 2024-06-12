import 'package:emplanner/services/schedule_service.dart';
import 'package:emplanner/widgets/new_semester_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:emplanner/models/school_year.dart';
import 'package:emplanner/providers/schedule_provider.dart';
import 'package:emplanner/models/semester.dart';

class EditAcademicYearDialog extends ConsumerStatefulWidget {
  const EditAcademicYearDialog({super.key});

  @override
  ConsumerState<EditAcademicYearDialog> createState() =>
      _EditAcademicYearDialogState();
}

class _EditAcademicYearDialogState
    extends ConsumerState<EditAcademicYearDialog> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _startDate;
  DateTime? _endDate;
  SchoolYear? _selectedSchoolYear;
  List<Semester> _filteredSemesters = [];

  Future<bool> _saveYear() async {
    if (_startDate != null && _endDate != null && _selectedSchoolYear != null) {
      SchoolYear year = SchoolYear(startDate: _startDate!, endDate: _endDate!);
      await ScheduleService.updateYear(
          _selectedSchoolYear!.id.toString(), year);

      return true;
    }
    return false;
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != (isStartDate ? _startDate : _endDate)) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _deleteSemester(Semester semester) {
    setState(() {
      _filteredSemesters.remove(semester);
    });
    // Implement additional delete logic if needed (e.g., API call)
  }

  @override
  Widget build(BuildContext context) {
    final years = ref.watch(yearsFutureProvider);
    final semesters = ref.watch(semesterFutureProvider);

    return years.when(
      data: (years) => AlertDialog(
        title: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.yellow[700],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8.0),
              topRight: Radius.circular(8.0),
            ),
          ),
          child: const Text(
            'Edit Academic Year',
            style: TextStyle(color: Colors.white),
          ),
        ),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                DropdownButtonFormField<SchoolYear>(
                  decoration: const InputDecoration(
                    labelText: 'School Year',
                  ),
                  value: _selectedSchoolYear,
                  onChanged: (SchoolYear? newValue) {
                    setState(() {
                      _selectedSchoolYear = newValue;
                      _startDate = newValue?.startDate;
                      _endDate = newValue?.endDate;
                    });
                  },
                  items: years
                      .map<DropdownMenuItem<SchoolYear>>((SchoolYear value) {
                    return DropdownMenuItem<SchoolYear>(
                      value: value,
                      child:
                          Text('${value.startDate.year}-${value.endDate.year}'),
                    );
                  }).toList(),
                ),
                TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Start date',
                    hintText: 'mm/dd/yyyy',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () {
                        _selectDate(context, true);
                      },
                    ),
                  ),
                  controller: TextEditingController(
                    text: _startDate == null
                        ? _selectedSchoolYear == null
                            ? ''
                            : '${_selectedSchoolYear!.startDate.month}/${_selectedSchoolYear!.startDate.day}/${_selectedSchoolYear!.startDate.year}'
                        : '${_startDate!.month}/${_startDate!.day}/${_startDate!.year}',
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'End date',
                    hintText: 'mm/dd/yyyy',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () {
                        _selectDate(context, false);
                      },
                    ),
                  ),
                  controller: TextEditingController(
                    text: _endDate == null
                        ? _selectedSchoolYear == null
                            ? ''
                            : '${_selectedSchoolYear!.endDate.month}/${_selectedSchoolYear!.endDate.day}/${_selectedSchoolYear!.endDate.year}'
                        : '${_endDate!.month}/${_endDate!.day}/${_endDate!.year}',
                  ),
                ),
                const SizedBox(height: 16.0),
                Container(
                  height: 120, // Fixed height for the container
                  child: SingleChildScrollView(
                    child: semesters.when(
                      data: (semesters) {
                        _filteredSemesters = semesters
                            .where(
                              (semester) =>
                                  semester.schoolYearId ==
                                  _selectedSchoolYear?.id,
                            )
                            .toList();

                        return Column(
                          children: _filteredSemesters
                              .map((semester) => ListTile(
                                    leading: const Icon(Icons.school),
                                    title: Text(semester.name),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        _deleteSemester(semester);
                                      },
                                    ),
                                  ))
                              .toList(),
                        );
                      },
                      error: (e, r) => Text('Error: $e'),
                      loading: () => const CircularProgressIndicator(),
                    ),
                  ),
                ),
                TextButton(
                  child: const Text(
                    'New Semester',
                    style: TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return NewSemesterDialog(
                          yearId: _selectedSchoolYear!.id.toString(),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            child: const Text('Save'),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await _saveYear();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Updated'),
                    duration: Duration(seconds: 2),
                    backgroundColor: Colors.green,
                  ),
                );
                await ref
                    .read(yearsStateNotifierProvider.notifier)
                    .fetchYears();
              }
            },
          ),
        ],
      ),
      error: (e, r) => Text('Error: $e'),
      loading: () => const CircularProgressIndicator(),
    );
  }
}
