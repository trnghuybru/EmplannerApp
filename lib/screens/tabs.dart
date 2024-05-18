import 'package:emplanner/screens/calendars.dart';
import 'package:emplanner/screens/dashboard.dart';
import 'package:emplanner/screens/settings.dart';
import 'package:emplanner/screens/tasks.dart';
import 'package:emplanner/widgets/main_drawer.dart';
import 'package:flutter/material.dart';

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
        activePage = const CalendarScreen();
      });
    }

    if (_selectedPageIndex == 2) {
      setState(() {
        activePageTitle = 'Task';
        activePage = const TasksScreen();
      });
    }

    return Scaffold(
      appBar: AppBar(
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
