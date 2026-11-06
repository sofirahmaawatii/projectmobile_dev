import 'package:flutter/material.dart';

import 'dashboard_screen.dart';
import 'crud_screen.dart';
import 'profile_screen.dart';
import 'post_page.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  static const Color purple = Color(0xFF6741A5);

  void _handleNavigate(int index) {
    if (index >= 0 && index < 4) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      DashboardScreen(onNavigate: _handleNavigate),
      const CrudScreen(),
      const ProfileScreen(),
      const PostPage(),
    ];

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: screens),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _handleNavigate,

        backgroundColor: Colors.white,
        selectedItemColor: purple,
        unselectedItemColor: Colors.grey,

        selectedFontSize: 11,
        unselectedFontSize: 11,

        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.edit_note_outlined),
            activeIcon: Icon(Icons.edit_note),
            label: 'Kelola Data',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper_outlined),
            activeIcon: Icon(Icons.newspaper),
            label: 'Berita',
          ),
        ],
      ),
    );
  }
}
