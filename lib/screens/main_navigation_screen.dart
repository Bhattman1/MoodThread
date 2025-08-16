import 'package:flutter/material.dart';
import 'package:moodthread/screens/home_screen.dart';
import 'package:moodthread/screens/friends_screen.dart';
import 'package:moodthread/screens/profile_screen.dart';
import 'package:moodthread/utils/app_theme.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 1; // Start with Home tab (middle)

  final List<Widget> _screens = [
    const FriendsScreen(),
    const HomeScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Friends Tab
                _buildTabItem(
                  index: 0,
                  icon: Icons.people_outline,
                  activeIcon: Icons.people,
                  label: 'Friends',
                ),
                
                // Home Tab (Center - Main)
                _buildHomeTab(),
                
                // Profile Tab
                _buildTabItem(
                  index: 2,
                  icon: Icons.person_outline,
                  activeIcon: Icons.person,
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final isActive = _currentIndex == index;
    
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
            decoration: BoxDecoration(
              color: isActive 
                  ? AppTheme.primaryColor.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isActive ? activeIcon : icon,
              color: isActive ? AppTheme.primaryColor : AppTheme.textSecondaryColor,
              size: MediaQuery.of(context).size.width * 0.06,
            ),
          ),
          
          SizedBox(height: MediaQuery.of(context).size.height * 0.005),
          
          Text(
            label,
            style: TextStyle(
              color: isActive ? AppTheme.primaryColor : AppTheme.textSecondaryColor,
              fontSize: MediaQuery.of(context).size.width * 0.025,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeTab() {
    final isActive = _currentIndex == 1;
    
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = 1),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Special Home Tab Design (like BeReal)
          Container(
            width: MediaQuery.of(context).size.width * 0.15,
            height: MediaQuery.of(context).size.width * 0.15,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isActive 
                    ? [AppTheme.primaryColor, AppTheme.primaryColor.withOpacity(0.8)]
                    : [AppTheme.textSecondaryColor.withOpacity(0.3), AppTheme.textSecondaryColor.withOpacity(0.1)],
              ),
              borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.075),
              boxShadow: isActive ? [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ] : null,
            ),
            child: Icon(
              Icons.home,
              color: isActive ? Colors.white : AppTheme.textSecondaryColor,
              size: MediaQuery.of(context).size.width * 0.07,
            ),
          ),
          
          SizedBox(height: MediaQuery.of(context).size.height * 0.005),
          
          Text(
            'Home',
            style: TextStyle(
              color: isActive ? AppTheme.primaryColor : AppTheme.textSecondaryColor,
              fontSize: MediaQuery.of(context).size.width * 0.025,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
