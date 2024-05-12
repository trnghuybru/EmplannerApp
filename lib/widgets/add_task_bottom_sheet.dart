import 'package:emplanner/widgets/buttons/cancel_button.dart';
import 'package:emplanner/widgets/buttons/secondary_buttons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTaskBottomSheet extends StatefulWidget {
  const NewTaskBottomSheet({super.key});

  @override
  State<NewTaskBottomSheet> createState() => _NewTaskBottomSheetState();
}

class _NewTaskBottomSheetState extends State<NewTaskBottomSheet> {
  final _titleController = TextEditingController();
  final _description = TextEditingController();
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return LayoutBuilder(builder: (ctx, constrains) {
      final width = constrains.maxWidth;

      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 30, 20, keyboardSpace + 16),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: SizedBox(
                        height: 18,
                        child: Image.asset('assets/images/logo.png')),
                  ),
                  Text(
                    'Course',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: const Color.fromARGB(255, 117, 117, 117)),
                  ),
                  DropdownButtonFormField(
                    items: const [
                      DropdownMenuItem(
                        child: Text('Japanese'),
                        value: 2,
                      ),
                      DropdownMenuItem(
                        child: Text('Japanese'),
                        value: 1,
                      ),
                      DropdownMenuItem(
                        child: Text('Japanese'),
                        value: 12,
                      ),
                    ],
                    onChanged: (i) {},
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        borderSide: const BorderSide(
                            color: Colors.grey), // Color of the border
                      ),
                      filled: true,
                      fillColor: Colors.grey[200], // Background color
                    ),
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  ),
                  Text(
                    'Title',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: const Color.fromARGB(255, 117, 117, 117)),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      fillColor: const Color.fromARGB(148, 238, 238, 238),
                      filled: true,
                    ),
                    validator: (value) {},
                  ),
                  Text(
                    'Due date',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: const Color.fromARGB(255, 117, 117, 117)),
                  ),
                  TextFormField(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(DateTime.now().year,
                            DateTime.now().month, DateTime.now().day + 30),
                      );
                      if (picked != null && picked != _selectedDate) {
                        setState(() {
                          _selectedDate = picked;
                        });
                      }
                    },
                    controller: TextEditingController(
                        text: _selectedDate != null
                            ? DateFormat.yMd().format(_selectedDate!)
                            : ''),
                    decoration: InputDecoration(
                        hintText: 'Select Date',
                        prefixIcon: const Icon(Icons.calendar_month_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        fillColor: const Color.fromARGB(148, 238, 238, 238),
                        filled: true,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 12)),
                  ),
                  Text(
                    'Type',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: const Color.fromARGB(255, 117, 117, 117)),
                  ),
                  DropdownButtonFormField(
                    items: const [
                      DropdownMenuItem(
                        child: Text('Japanese'),
                        value: 2,
                      ),
                      DropdownMenuItem(
                        child: Text('Japanese'),
                        value: 1,
                      ),
                      DropdownMenuItem(
                        child: Text('Japanese'),
                        value: 12,
                      ),
                    ],
                    onChanged: (i) {},
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        borderSide: const BorderSide(
                            color: Colors.grey), // Color of the border
                      ),
                      filled: true,
                      fillColor: Colors.grey[200], // Background color
                    ),
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  ),
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: const Color.fromARGB(255, 117, 117, 117)),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      fillColor: const Color.fromARGB(148, 238, 238, 238),
                      filled: true,
                    ),
                    maxLines: null,
                    validator: (value) {},
                  ),
                  Row(
                    children: [
                      const CancelButton(),
                      SecondaryButton(
                        title: const Text('Add Task'),
                        icon: Icons.add_rounded,
                        onPressed: () {},
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
