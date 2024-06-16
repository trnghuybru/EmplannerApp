import 'package:emplanner/screens/calendars.dart';
import 'package:emplanner/screens/dashboard.dart';
import 'package:emplanner/screens/exams.dart';
import 'package:emplanner/screens/schedules.dart';
import 'package:emplanner/screens/profile.dart';
import 'package:emplanner/screens/tasks.dart';
import 'package:emplanner/widgets/edit_year_dialog.dart';
import 'package:emplanner/widgets/main_drawer.dart';
import 'package:emplanner/widgets/new_class_dialog.dart';
import 'package:emplanner/widgets/new_course_dialog.dart';
import 'package:emplanner/widgets/new_year_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;
  late Widget activePage;
  late String activePageTitle;

  @override
  void initState() {
    super.initState();
    _updateActivePage(_selectedPageIndex);
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
      _updateActivePage(index);
    });
  }

  void _setScreen(String identifier) {
    if (identifier == 'profile') {
      Navigator.of(context).pop();
      setState(() {
        activePage = const ProfileScreen();
        activePageTitle = 'Profile';
      });
    }
  }

  void _updateActivePage(int index) {
    switch (index) {
      case 0:
        activePage = const DashboardScreen();
        activePageTitle = 'Dashboard';
        break;
      case 1:
        activePage = const CalendarScreen();
        activePageTitle = 'Calendar';
        break;
      case 2:
        activePage = const TasksScreen();
        activePageTitle = 'Tasks';
        break;
      case 3:
        activePage = const ExamsScreen();
        activePageTitle = 'Exams';
        break;
      case 4:
        activePage = const SchedulesScreen();
        activePageTitle = 'Schedules';
        break;
      default:
        activePage = const DashboardScreen();
        activePageTitle = 'Dashboard';
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
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
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 30,
              offset: Offset(0, 20),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            onTap: _selectPage,
            currentIndex: _selectedPageIndex,
            items: const [
              BottomNavigationBarItem(
                icon: FaIcon(
                  FontAwesomeIcons.house,
                  color: Color.fromARGB(255, 212, 225, 245),
                ),
                activeIcon: FaIcon(
                  FontAwesomeIcons.house,
                  color: Colors.amber,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(
                  FontAwesomeIcons.calendar,
                  color: Color.fromARGB(255, 212, 225, 245),
                ),
                activeIcon: FaIcon(
                  FontAwesomeIcons.solidCalendar,
                  color: Colors.amber,
                ),
                label: 'Calendar',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(
                  FontAwesomeIcons.listCheck,
                  color: Color.fromARGB(255, 212, 225, 245),
                ),
                activeIcon: FaIcon(
                  FontAwesomeIcons.listCheck,
                  color: Colors.amber,
                ),
                label: 'Tasks',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(
                  FontAwesomeIcons.spellCheck,
                  color: Color.fromARGB(255, 212, 225, 245),
                ),
                activeIcon: FaIcon(
                  FontAwesomeIcons.spellCheck,
                  color: Colors.amber,
                ),
                label: 'Exams',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(
                  FontAwesomeIcons.calendarPlus,
                  color: Color.fromARGB(255, 212, 225, 245),
                ),
                activeIcon: FaIcon(
                  FontAwesomeIcons.solidCalendarPlus,
                  color: Colors.amber,
                ),
                label: 'Schedules',
              ),
            ],
            showSelectedLabels: false,
          ),
        ),
      ),
    );
  }
}
