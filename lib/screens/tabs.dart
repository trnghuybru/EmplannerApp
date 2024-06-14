import 'package:emplanner/models/school_year.dart';
import 'package:emplanner/screens/calendars.dart';
import 'package:emplanner/screens/dashboard.dart';
import 'package:emplanner/screens/exams.dart';
import 'package:emplanner/screens/schedules.dart';
import 'package:emplanner/screens/settings.dart';
import 'package:emplanner/screens/tasks.dart';
import 'package:emplanner/widgets/edit_year_dialog.dart';
import 'package:emplanner/widgets/main_drawer.dart';
import 'package:emplanner/widgets/new_class_dialog.dart';
import 'package:emplanner/widgets/new_course_dialog.dart';
import 'package:emplanner/widgets/new_year_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;
  late Widget activePage;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen(String indentifier) {
    Navigator.of(context).pop();
    //man hinh setting
    if (indentifier == 'settings') {
      print("setting");
      setState(() {
        activePage = const SettingsScreen();
      });
    }
    //man hinh schedules
  }

  @override
  void initState() {
    super.initState();
    activePage = const DashboardScreen();
  }

  @override
  Widget build(BuildContext context) {
    var activePageTitle = 'Dashboard';

    if (_selectedPageIndex == 0) {
      setState(() {
        activePage = const DashboardScreen();
      });
    }

    if (_selectedPageIndex == 1) {
      setState(() {
        activePageTitle = 'Calendar';
        activePage = const CalendarScreen();
      });
    }

    if (_selectedPageIndex == 2) {
      setState(() {
        activePageTitle = 'Task';
        activePage = const TasksScreen();
      });
    }

    if (_selectedPageIndex == 3) {
      setState(() {
        activePageTitle = 'Schedules';
        activePage = const SchedulesScreen();
      });
    }

    if (_selectedPageIndex == 4) {
      setState(() {
        activePageTitle = 'Exams';
        activePage = const ExamsScreen();
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: activePageTitle == 'Schedules'
          ? SpeedDial(
              animatedIcon: AnimatedIcons.add_event,
              spacing: 8,
              spaceBetweenChildren: 8,
              children: [
                SpeedDialChild(
                  shape: const CircleBorder(side: BorderSide.none),
                  child: const CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 250, 187, 24),
                    child: Icon(Icons.school, color: Colors.white),
                  ),
                  label: 'New School Year',
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const NewAcademicYearDialog();
                      },
                    );
                  },
                ),
                SpeedDialChild(
                  shape: const CircleBorder(side: BorderSide.none),
                  child: const CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 0, 202, 231),
                    child: Icon(Icons.calendar_today, color: Colors.white),
                  ),
                  label: 'Edit School Year',
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const EditAcademicYearDialog();
                      },
                    );
                  },
                ),
                SpeedDialChild(
                  shape: const CircleBorder(side: BorderSide.none),
                  child: const CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 0, 223, 204),
                    child: Icon(Icons.class_, color: Colors.white),
                  ),
                  label: 'New Class',
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const CreateClassDialog();
                      },
                    );
                  },
                ),
                SpeedDialChild(
                  shape: const CircleBorder(side: BorderSide.none),
                  child: const CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 254, 138, 126),
                    child: Icon(Icons.manage_accounts, color: Colors.white),
                  ),
                  label: 'New Course',
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const NewSubjectDialog();
                      },
                    );
                  },
                ),
              ],
            )
          : null,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: activePageTitle == 'Dashboard'
            ? Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: SizedBox(
                  width: 150,
                  child: Image.asset('assets/images/logo.png'),
                ),
              )
            : Row(
                children: [
                  Image.asset('assets/images/icon_logo.png'),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(activePageTitle,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          )),
                ],
              ),
        surfaceTintColor: Colors.transparent,
      ),
      endDrawer: MainDrawer(
        onSelectScreen: _setScreen,
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
              color: Color.fromARGB(255, 212, 225, 245),
            ),
            activeIcon: Icon(
              Icons.home_rounded,
              color: Color.fromARGB(255, 250, 187, 24),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.calendar_month_outlined,
              color: Color.fromARGB(255, 212, 225, 245),
            ),
            activeIcon: Icon(
              Icons.calendar_month_rounded,
              color: Color.fromARGB(255, 250, 187, 24),
            ),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.av_timer_outlined,
              color: Color.fromARGB(255, 212, 225, 245),
            ),
            activeIcon: Icon(
              Icons.av_timer_rounded,
              color: Color.fromARGB(255, 250, 187, 24),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.note_alt_rounded,
              color: Color.fromARGB(255, 212, 225, 245),
            ),
            activeIcon: Icon(
              Icons.note_alt_rounded,
              color: Color.fromARGB(255, 250, 187, 24),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outlined,
              color: Color.fromARGB(255, 212, 225, 245),
            ),
            activeIcon: Icon(
              Icons.person_rounded,
              color: Color.fromARGB(255, 250, 187, 24),
            ),
            label: '',
          ),
        ],
        showSelectedLabels: false,
      ),
    );
  }
}
