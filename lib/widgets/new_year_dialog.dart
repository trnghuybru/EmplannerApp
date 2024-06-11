import 'package:emplanner/services/schedule_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NewAcademicYearDialog extends StatefulWidget {
  const NewAcademicYearDialog({super.key});

  @override
  State<NewAcademicYearDialog> createState() => _NewAcademicYearDialogState();
}

class _NewAcademicYearDialogState extends State<NewAcademicYearDialog> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _startDate;
  DateTime? _endDate;

  Future<bool> _saveYear() async {
    return await ScheduleService.saveYears(_startDate!, _endDate!);
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
          'New Academic Year',
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
              const Text(
                'What Are Academic Years?\n\nAn academic year and its terms are used to represent your school year and any terms (e.g., semesters, trimesters, quarters) that you may have.',
                style: TextStyle(fontSize: 14.0),
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
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _saveYear();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Created New School Year!'),
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
