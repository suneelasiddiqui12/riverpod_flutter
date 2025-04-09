import 'package:flutter/material.dart';
import 'package:riverpod_flutter/constants/app_colors.dart';
import 'package:riverpod_flutter/screens/home_screen.dart'; // Import for HomeScreen
import 'package:riverpod_flutter/screens/profile_screen.dart'; // Import for ProfileScreen
import 'package:riverpod_flutter/screens/settings_screen.dart'; // Import for SettingsScreen

class BottomNavigationBarScreen extends StatefulWidget {
  const BottomNavigationBarScreen({super.key});

  @override
  _BottomNavigationBarScreenState createState() => _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {
  int _currentIndex = 0; // Default index for HomeScreen

  final List<Widget> _screens = [
    HomeScreen(),
    ProfileScreen(),
    SettingsScreen(), // Add more screens here as needed
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index; // Update the current index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex, // Show the selected screen
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.primaryColor,
        selectedItemColor: Colors.white, // Selected item color
        unselectedItemColor: Colors.white70, // Unselected item color
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
        currentIndex: _currentIndex, // Set the current index dynamically
        onTap: _onItemTapped, // Handle item taps
      ),
    );
  }
}