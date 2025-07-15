import 'package:flutter/material.dart';
import '../utils/nepali_strings.dart';
import 'home_screen.dart';
import 'top_due_screen.dart';
import 'reports_screen.dart';
import 'settings_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    TopDueScreen(),
    ReportsScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 10,
            ),
          ],
        ),
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home),
              label: NepaliStrings.home,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.warning_amber_outlined),
              activeIcon: const Icon(Icons.warning_amber),
              label: NepaliStrings.topDue,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.insert_chart_outlined),
              activeIcon: const Icon(Icons.insert_chart),
              label: NepaliStrings.reports,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.settings_outlined),
              activeIcon: const Icon(Icons.settings),
              label: NepaliStrings.settings,
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
        ),
      ),
    );
  }
}
