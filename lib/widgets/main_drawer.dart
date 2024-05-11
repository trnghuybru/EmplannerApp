import 'dart:io';

import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key, required this.onSelectScreen});
  final void Function(String indentifier) onSelectScreen;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: 270,
        padding: const EdgeInsets.fromLTRB(20, 20, 0, 470),
        child: Drawer(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                SizedBox(
                  height: 150,
                  child: DrawerHeader(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                  width: 20,
                                  child: Image.asset(
                                      'assets/images/icon_logo.png')),
                              SizedBox(
                                  width: 100,
                                  child: Image.asset('assets/images/logo.png')),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Tanjiro Kamado',
                                  style: TextStyle(fontSize: 14),
                                ),
                                Text(
                                  'IT Student',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                )
                              ],
                            ),
                            SizedBox(width: 9),
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                  'https://mighty.tools/mockmind-api/content/human/41.jpg'),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.calendar_month,
                      size: 16,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    title: Text(
                      'Schedules',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontSize: 16,
                          ),
                    ),
                    onTap: () {
                      onSelectScreen('schedules');
                    },
                  ),
                ),
                const SizedBox(height: 9),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.settings_rounded,
                      size: 16,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    title: Text(
                      'Settings',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 16,
                          ),
                    ),
                    onTap: () {
                      onSelectScreen('settings');
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
