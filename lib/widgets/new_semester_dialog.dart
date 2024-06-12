import 'package:emplanner/providers/courses_provider.dart';
import 'package:emplanner/providers/schedule_provider.dart';
import 'package:emplanner/services/schedule_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewSemesterDialog extends ConsumerStatefulWidget {
  const NewSemesterDialog({super.key, required this.yearId});
  final String yearId;
  @override
  ConsumerState<NewSemesterDialog> createState() => _NewSemesterDialogState();
}

class _NewSemesterDialogState extends ConsumerState<NewSemesterDialog> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _startDate;
  DateTime? _endDate;
  final TextEditingController _tenHocKyController = TextEditingController();

  Future<bool> _saveSemester() async {
    return await ScheduleService.saveSemester(
      widget.yearId,
      _tenHocKyController.text,
      _startDate!,
      _endDate!,
    );
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
          'New Semester',
          style: TextStyle(color: Colors.white),
        ),
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
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
                      ? ''
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
                      ? ''
                      : '${_endDate!.month}/${_endDate!.day}/${_endDate!.year}',
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter semester name',
                ),
                controller: _tenHocKyController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tên học kì không được để trống';
                  }
                  return null;
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
          child: const Text('Create'),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              _saveSemester();
              await ref
                  .read(semesterStateNotifierProvider.notifier)
                  .fetchSemesters();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Created New Semester!'),
                  duration: Duration(seconds: 2),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
