import 'package:flutter/material.dart';
import 'package:riverpod_flutter/constants/app_colors.dart';
import 'package:riverpod_flutter/screens/bottom_navigation_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          "Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Center(
        child: Text(
          "User Profile Information",
          style: TextStyle(fontSize: 20, color: AppColors.textColor),
        ),
      ),
        bottomNavigationBar: BottomNavigationBarScreen()
    );
  }
}