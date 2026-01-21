import 'package:flutter/material.dart';
import 'package:cleanapp/pages/customerhome.dart';
import 'package:cleanapp/pages/customernotification.dart';
import 'package:cleanapp/pages/customer_profile.dart';

class CustomerBottom extends StatefulWidget {
  const CustomerBottom({super.key});

  @override
  State<CustomerBottom> createState() => _CustomerBottomState();
}

class _CustomerBottomState extends State<CustomerBottom> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    CustomerHome(), // Home screen
    CustomerNotification(), // Notifications screen
    CustomerProfile(), // Profile screen
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue, // Active icon color
        unselectedItemColor: Colors.grey, // Inactive icon color
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
