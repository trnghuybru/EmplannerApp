import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:emplanner/screens/tabs.dart';
import 'package:emplanner/widgets/secondary_buttons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //need to change to ListView
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('MMM d, yyyy').format(DateTime.now()),
                      style: const TextStyle(
                        color: Color.fromARGB(255, 131, 131, 131),
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Today',
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SecondaryButton(
                  icon: Icons.add_rounded,
                  title: const Text('Add Task'),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 20, bottom: 15),
            child: DatePicker(
              DateTime.now(),
              height: 90,
              width: 70,
              initialSelectedDate: DateTime.now(),
              selectionColor: const Color.fromARGB(255, 250, 187, 24),
              selectedTextColor: Colors.white,
              dateTextStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 73, 73, 73),
              ),
            ),
          ),
          _TaskWidget(),
          _TaskWidget(),
          _TaskWidget(),
          _TaskWidget(),
          _TaskWidget()
        ],
      ),
    );
  }

  _TaskWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      height: 112,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 242, 243, 255),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        children: [
          Container(
            width: 18,
            decoration: const BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
          ),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Herbical App Redesign',
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'UI/UX Design',
                            style: TextStyle(
                              color: Color.fromARGB(255, 113, 113, 113),
                              fontSize: 12.0,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 125),
                      Icon(Icons.more_vert_rounded)
                    ],
                  ),
                  Divider(
                    color: Color.fromARGB(29, 0, 0, 0),
                    thickness: 1.0,
                    height: 20,
                    indent: 5,
                    endIndent: 20,
                  ),
                  Row(
                    children: [
                      Icon(Icons.access_time_rounded, size: 15),
                      SizedBox(width: 5),
                      Text(
                        '10:00 PM - 01:00 AM',
                        style: TextStyle(
                          color: Color.fromARGB(255, 113, 113, 113),
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
